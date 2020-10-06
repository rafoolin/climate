import 'dart:io';

import 'package:climate/src/exceptions/exceptions.dart';
import 'package:climate/src/models/models.dart';
import 'package:climate/src/repository/repositories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Repository {
  // API direct connection
  Api _api = Api();

  // database's Objects
  LocationClimateDao _climateDao = LocationClimateDao();
  ConsolidatedWeatherDao _weatherDao = ConsolidatedWeatherDao();
  LocationDao _locationDao = LocationDao();

  // ------------------------------------ LOCATION ------------------------------------
  //
  /// Return location information, and a 5 day forecasts.
  ///[woeid] is Where On Earth ID. [Docs](http://developer.yahoo.com/geo/geoplanet/guide/concepts.html)
  ///
  /// Examples:
  /// --
  /// ```dart
  ///  location(woeid:44418);    // London
  ///  location(woeid:2487956);  // San Francisco
  /// ```

  Future<LocationClimate> location({@required int woeid}) async {
    try {
      return await _api
          // Fetch Climate from API
          .location(woeid: woeid)
          // No error occurred, so save/update climate on database
          .then((climate) async => await _climateDao
              .insertOrUpdate(climate: climate)
              .then((value) => climate));
    } on SocketException catch (_) {
      // There is a problem with the internet
      // so fetch climate from database
      return await _climateDao.location(woeid: woeid).then(
            (climate) => (climate == null)
                // If climate for [woeid] can't be fetched neither from API
                // nor from database, throws error
                ? throw NoInternetException(
                    'Need internet connection to get climate info!')
                : climate,
          );
    }
  }

  // -------------------------------- LOCATION SEARCH --------------------------------
  //
  /// Return found location.
  ///
  /// Either [query] or [lattlong] need to be present.
  ///
  /// [query] is text to search for.
  ///
  /// [lattlong] is coordinates to search for locations near. Comma separated lattitude and longitude e.g. "36.96,-122.02".
  ///
  /// Examples
  /// --
  /// ```dart
  ///  locationSearch(query:'san');
  ///  locationSearch(query:'london');
  ///  locationSearch(lattlong:'36.96,-122.02');
  ///  locationSearch(lattlong:'50.068,-5.316');
  /// ```

  Future<List<Location>> locationSearch({String query, String lattlong}) async {
    try {
      // search for query or lattlong from API
      return await _api.locationSearch(query: query, lattlong: lattlong).then(
            (locations) async => await _locationDao
                // No error occurred and API returned some locations.
                // Save the first one to the local database.
                .insert(location: locations.first)
                .then((value) => locations),
          );
    } on SocketException catch (_) {
      // There is a problem with the internet.
      // Try query locations from database.
      return await _locationDao
          .locationSearch(query: query, lattlong: lattlong)
          .then(
            (localLocations) => (localLocations.isEmpty)
                ?
                // There's no data on database so ask the user for the internet
                throw NoInternetException('Please connect to the internet!')
                : localLocations,
          );
    }
  }

  // ---------------------------------- LOCATION DAY ----------------------------------
  //
  /// Return Source information and forecast history for a particular day & location.
  ///
  /// [woeid] is where On Earth ID. [Docs](http://developer.yahoo.com/geo/geoplanet/guide/concepts.html)
  ///
  /// [date] in the format yyyy/mm/dd. Most location have data from early 2013 to 5-10 days in the future.
  ///
  /// Examples:
  /// --
  /// ```dart
  /// // London on 27th Apr 2013
  /// locationDay(woeid:44418, date: DateTime.parse(2013-4-27));
  /// // San Francisco on 30th April 2013
  /// locationDay(woeid:2487956, date: DateTime.parse(2013-4-30));
  /// ```

  Future<ConsolidatedWeather> locationDay({
    @required int woeid,
    @required DateTime date,
  }) async {
    try {
      // Fetch forecast from API in [date]
      return await _api
          .locationDay(woeid: woeid, date: date)
          // No error occurred, so save/update weather on the database
          .then(
            (weather) async => await _weatherDao
                .insertOrUpdate(woeid: woeid, weather: weather)
                .then((value) => weather),
          );
    } on SocketException catch (_) {
      // There is a problem with the internet
      // so fetch weather from database
      return await _weatherDao.locationDay(woeid: woeid, date: date).then(
            (weather) => (weather == null)
                // If weather for [woeid] in [date] couldn't be found neither from API
                // nor from database, throws an error
                ? throw NoInternetException(
                    'Need internet connection to get climate info!')
                : weather,
          );
    }
  }

  /// Clear all saved climates from the Climate Table(Store) and weather store.
  Future<int> clearClimates() async {
    return _weatherDao.clear().then((value) async => await _climateDao.clear());
  }
}
