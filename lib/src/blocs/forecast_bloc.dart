import 'dart:async';
import 'dart:collection';

import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/configs/configs.dart';
import 'package:climate/src/exceptions/exceptions.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/repository/repositories.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ForecastBloc extends Bloc {
  final Repository _repository = Repository();
  final PreferencesBloc preferencesBloc;
  final _locations = BehaviorSubject<Map<String, bool>>();
  final _forecast = BehaviorSubject<LocationClimate>();
  final _todayForecast = BehaviorSubject<ConsolidatedWeather>();
  final _forecastColor = BehaviorSubject<Color>();
  // All cached places
  Map _cachePlaces = HashMap<String, bool>();
  // search result
  Map _searchResult;

  ForecastBloc({this.preferencesBloc}) {
    // Clear CLimate data every 6 days.
    // API contains forecast for next 6 days of a location
    Timer.periodic(Duration(days: 6), (timer) async {
      await _repository.clearClimates();
    });
    // Update forecast if location changed
    preferencesBloc.locationStream
        .listen((event) async => await fetchForecast());
  }

  // ================================================================================
  // =                               SEARCH LOCATIONS                               =
  // ================================================================================
  /// Search Locations Stream
  get searchedLocationsStream => _locations.stream;
  Future<void> locationSearch({String query, String lattlong}) async {
    // Fetch saved places
    CustomPreferences pref = CustomPreferences();
    List<String> places = await pref.fetchPlacesPreference();
    // Used insertion-ordered hash-table to match the API returned order
    _searchResult = LinkedHashMap<String, bool>();

    // Fetch Location model of each saved places
    await _repository
        // Either from API or database
        .locationSearch(query: query, lattlong: lattlong)
        .then((lst) {
      lst.forEach((location) {
        // Update cache
        // Also add it to current search result
        _searchResult[location.title] =
            _cachePlaces[location.title] = places.contains(location.title);
      });
      // Add search result ma to stream
      _locations.add(_searchResult);
    }).catchError((onError) => _locations.addError(onError));
  }

  /// Add or remove a place/location from saved places
  Future<void> changePlaceStatus({String title, bool chosen = false}) async {
    // fetch saved places
    CustomPreferences _pref = CustomPreferences();
    List<String> places = await _pref.fetchPlacesPreference();
    if (chosen)
      places.add(title);
    else
      places.remove(title);
    // Apply updates to caches
    _cachePlaces[title] = chosen;
    _searchResult[title] = chosen;
    // Inform Pref bloc to update any changes in saved places
    await preferencesBloc
        .savePlaces(names: places.toSet().toList())
        // Update search bloc result
        .then((value) => _locations.add(_searchResult))
        .catchError((onError) => _locations.addError(onError));
  }

  /// Clear search results
  Future<void> clearSearch() async {
    // Clear last search result from the UI
    return _locations.add({});
  }

  // ================================================================================
  // =                                   FORECAST                                   =
  // ================================================================================
  /// Forecast Stream
  ValueStream<LocationClimate> get forecastStream => _forecast.stream;

  /// Fetch climate for the location
  Future<void> fetchForecast() async {
    CustomPreferences preferences = CustomPreferences();

    // Reset the timezone if needed
    await preferencesBloc.resetTimezone();
    // Fetch user current location
    await preferences
        .fetchLocationPreference()
        // Fetch its Location model[either API or database]
        // We need Woeid to get Climate information
        .then(
          (title) async => title.isEmpty
              // If no location is chosen
              ? throw EmptyLocationException('No location is chosen!')
              : await _repository.locationSearch(query: title),
        )
        .then((locations) async =>
            // Fetch Weather/Climate information [either API or database]
            await _repository.location(woeid: locations.first.woeid))
        // Add climate to stream
        .then((climate) {
      _catchTodayForecast(climate: climate);
      return _forecast.add(climate);
    }).catchError((onError) async {
      // When there is an error add default color to stream
      _forecastColor.add(CustomColor.defaultColor);
      _todayForecast.addError(onError);
      return _forecast.addError(onError);
    });
  }

  // ================================================================================
  // =                                   TimeZoneName                               =
  // ================================================================================
  /// Timezone name stream
  get timezoneNameStream =>
      Rx.combineLatest2<LocationClimate, TimezoneChoice, String>(
              forecastStream, preferencesBloc.timezoneStream,
              (climate, timezoneChoice) {
        // Return timezone name based on the chosen time zone
        // or of the location status if the [TimezoneChoice.LOCATION] is chosen.
        return UnitConverter.timezoneName(
          climateTimezoneName: climate.timezoneName,
          timezone: timezoneChoice,
        );
      })
          .
          // On error return UTC
          onErrorReturn('UTC');

  // ================================================================================
  // =                               ForecastColor                                  =
  // ================================================================================
  /// Climate color condition stream
  get climateColorStream => _forecastColor.stream;

  // ================================================================================
  // =                             TODAY  Forecast                                  =
  // ================================================================================
  /// Climate color condition stream
  get todayForecastStream => _todayForecast.stream;

  void _catchTodayForecast({LocationClimate climate}) async {
    //  Time in user local timezone
    DateTime now = DateTime.now();
    // Today without  hours, minutes and seconds in UTC
    DateTime today = DateTime.utc(now.year, now.month, now.day);
    List<ConsolidatedWeather> climates = climate.consolidatedWeather;

    for (var i = 0; i < climates.length; i++) {
      // First date equals today
      if (climates[i].applicableDate.isAtSameMomentAs(today)) {
        _todayForecast.add(climates[i]);
        _forecastColor.add(CustomColor.weatherStateColor(
            weatherStateAbbr: climates[i].weatherStateAbbr));
        return;
      }
    }

    // NO data found for today, fetch explicitly weather for today
    await _repository
        .locationDay(woeid: climate.woeid, date: today)
        .then((fetched) {
      _todayForecast.add(fetched);
      /* 
         In cases that the local date is one day(actually a few hours) 
         before the UTC time:
         for example UTC is OCt 9, 2020
         and the user local date is Oct 8, 2020(a few hours to Oct 9)
         in these situations I decided to fetch Oct 8 for the user.
         
         In API it only returns [ConsolidatedWeather] for that date
         So for other info like sunrise, sunset,..
         I had to pass null.

         API approach is that it shows oct 9, climate for user as today even if
         in user timezone(or location timezone) is oct 8.

      */
      // Add this date to remaining dates
      _forecast.add(
        LocationClimate(
          consolidatedWeather: [fetched] + climate.consolidatedWeather,
          lattLong: climate.lattLong,
          locationType: climate.locationType,
          parent: climate.parent,
          sources: climate.sources,
          sunRise: null,
          sunSet: null,
          time: null,
          timeStr: climate.timeStr,
          timezone: climate.timezone,
          timezoneName: climate.timezoneName,
          title: climate.title,
          woeid: climate.woeid,
        ),
      );
      _forecastColor.add(CustomColor.weatherStateColor(
          weatherStateAbbr: fetched.weatherStateAbbr));
    }).catchError((onError) {
      _todayForecast.addError(onError);
      _forecastColor.add(CustomColor.defaultColor);
    });
  }

  /// Dispose streams
  void dispose() {
    _locations.close();
    _forecast.close();
    _forecastColor.close();
    _todayForecast.close();
  }
}
