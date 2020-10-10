import 'package:climate/src/blocs/blocs.dart';
import 'package:climate/src/configs/configs.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PreferencesBloc extends Bloc {
  final CustomPreferences _pref = CustomPreferences();
  final _theme = BehaviorSubject<ThemeData>();
  final _location = BehaviorSubject<String>();
  final _temp = BehaviorSubject<TempUnit>();
  final _wind = BehaviorSubject<WindUnit>();
  final _pressure = BehaviorSubject<PressureUnit>();
  final _distance = BehaviorSubject<DistanceUnit>();
  final _precipitation = BehaviorSubject<String>();
  final _places = BehaviorSubject<List<String>>();
  final _placesLocation = BehaviorSubject<List<Location>>();
  final _timezone = BehaviorSubject<TimezoneChoice>();

  // ================================================================================
  // =                                 THEME STREAM                                 =
  // ================================================================================

  /// Theme Stream
  get themeStream => _theme.stream;
  Future<void> fetchTheme() async {
    await _pref
        .fetchThemePreference()
        .then((value) => _theme.add(value ? darkTheme : lightTheme))
        .catchError((onError) => _theme.addError(onError));
  }

  Future<void> saveTheme({bool isDark = false}) async {
    await _pref
        .saveThemePreference(isDark: isDark)
        .then((value) => _theme.add(isDark ? darkTheme : lightTheme))
        .catchError((onError) => _theme.addError(onError));
  }

  // ================================================================================
  // =                                LOCATION STREAM                               =
  // ================================================================================

  /// Location stream
  get locationStream => _location.stream;

  /// save Location
  Future<void> saveLocation({String location}) async {
    await _pref
        .saveLocationPreference(location: location)
        .then((value) => _location.add(location))
        .catchError((onError) => _location.addError(onError));
  }

  /// fetch Location
  Future<void> fetchLocation() async {
    await _pref
        .fetchLocationPreference()
        .then((value) => _location.add(value))
        .catchError((onError) => _location.addError(onError));
  }

  // ================================================================================
  // =                                  TEMPERATURE                                 =
  // ================================================================================

  /// Temperature stream
  get tempStream => _temp.stream;

  /// save temperature
  Future<void> saveTemperature({TempUnit unit}) async {
    await _pref
        .saveTempPreference(unit: unit)
        .then((value) => _temp.add(unit))
        .catchError((onError) => _temp.addError(onError));
  }

  /// fetch temperature
  Future<void> fetchTemperature() async {
    await _pref
        .fetchTempPreference()
        .then((value) => _temp.add(value))
        .catchError((onError) => _temp.addError(onError));
  }

  // ================================================================================
  // =                                  WIND SPEED                                  =
  // ================================================================================
  /// Wind Speed stream
  get windStream => _wind.stream;

  /// save Wind Speed
  Future<void> saveWind({WindUnit unit}) async {
    await _pref
        .saveWindPreference(unit: unit)
        .then((value) => _wind.add(unit))
        .catchError((onError) => _wind.addError(onError));
  }

  /// fetch Wind Speed
  Future<void> fetchWind() async {
    await _pref
        .fetchWindPreference()
        .then((value) => _wind.add(value))
        .catchError((onError) => _wind.addError(onError));
  }

  // ================================================================================
  // =                                   PRESSURE                                   =
  // ================================================================================

  /// Pressure stream
  get pressureStream => _pressure.stream;

  /// fetch Pressure
  Future<void> fetchPressure() async {
    await _pref
        .fetchPressurePreference()
        .then((value) => _pressure.add(value))
        .catchError((onError) => _pressure.addError(onError));
  }

  /// save Pressure
  Future<void> savePressure({PressureUnit unit}) async {
    await _pref
        .savePressurePreference(unit: unit)
        .then((value) => _pressure.add(unit))
        .catchError((onError) => _pressure.addError(onError));
  }

  // ================================================================================
  // =                                   DISTANCE                                   =
  // ================================================================================

  /// Distance stream
  get distanceStream => _distance.stream;

  /// fetch Distance
  Future<void> fetchDistance() async {
    await _pref
        .fetchDistancePreference()
        .then((value) => _distance.add(value))
        .catchError((onError) => _distance.addError(onError));
  }

  /// save Distance
  Future<void> saveDistance({DistanceUnit unit}) async {
    await _pref
        .saveDistancePreference(unit: unit)
        .then((value) => _distance.add(unit))
        .catchError((onError) => _distance.addError(onError));
  }

  // ================================================================================
  // =                                    PLACES                                    =
  // ================================================================================

  /// locations stream
  ///
  /// `current` is the current location key.
  ///
  /// `places` is the other places key.
  //TODO: Isn't Used, delete it if is useless
  get currentLocationPlacesStream =>
      Rx.combineLatest2<List<String>, String, Map<String, dynamic>>(
        _places.stream,
        _location,
        (List<String> places, String currentLocation) => {
          "current": currentLocation,
          "places": places,
        },
      );

  /// Places stream
  get placesStream => _places.stream;

  /// fetch Places
  Future<void> fetchPlaces() async {
    await _pref
        .fetchPlacesPreference()
        .then((value) => _places.add(value))
        .catchError((onError) => _places.addError(onError));
  }

  /// save Places
  Future<void> savePlaces({List<String> names}) async {
    await _pref
        .savePlacesPreference(names: names)
        .then((value) => _places.add(names))
        .catchError((onError) => _places.addError(onError));
  }

  /// Delete a place
  Future<void> delPlace({String title}) async {
    String curLocation = await _pref.fetchLocationPreference();
    List<String> places = await _pref.fetchPlacesPreference();

    if (curLocation.compareTo(title) == 0)
      await _pref
          .saveLocationPreference(location: '')
          .then((value) => _location.add(''))
          .catchError((onError) => _location.addError(onError));

    await _pref
        .savePlacesPreference(names: places..remove(title))
        .then((value) => _places.add(places..remove(title)))
        .catchError((onError) => _places.addError(onError));
  }

  // ================================================================================
  // =                                  Timezone                                    =
  // ================================================================================

  /// Timezone stream
  get timezoneStream => _timezone.stream;

  /// Fetch Timezone
  Future<void> fetchTimezone() async {
    await _pref
        .fetchTimezonePreference()
        .then((value) => _timezone.add(value))
        .catchError((onError) => _timezone.addError(onError));
  }

  /// save Timezone
  Future<void> saveTimezone({TimezoneChoice timezone}) async {
    await _pref
        .saveTimezonePreference(timezone: timezone)
        .then((value) => _timezone.add(timezone))
        .catchError((onError) => _timezone.addError(onError));
  }

  /// Reset Saved timezone to UTC only if it is on Location timezone mode.
  /// It is useful when location is changed.
  Future<void> resetTimezone() async {
    await _pref.fetchTimezonePreference().then((timezone) async {
      // It's not UTC AND It's not Local timezone
      // then reset to UTC
      if (timezone == TimezoneChoice.LOCATION)
        await saveTimezone(timezone: TimezoneChoice.UTC);
    });
  }

  void dispose() {
    _theme.close();
    _location.close();
    _temp.close();
    _wind.close();
    _pressure.close();
    _distance.close();
    _precipitation.close();
    _places.close();
    _placesLocation.close();
    _timezone.close();
  }
}
