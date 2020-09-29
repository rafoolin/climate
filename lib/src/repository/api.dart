import 'dart:convert';
import 'package:climate/src/exceptions/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:climate/src/models/models.dart';

class Api {
  String baseUrl = 'https://www.metaweather.com/api';

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
    var response = await http.get('$baseUrl/location/$woeid/');
    if (response.statusCode == 200) {
      var result = json.decode(utf8.decode(response.bodyBytes));
      return LocationClimate.fromJson(result);
    }
    return null;
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
    List<Location> locations = [];

    // Either query or lattlong need to be present.
    assert((query == null && lattlong != null) ||
        (query != null && lattlong == null));

    // Remove spaces.
    query = query?.trim();
    lattlong = lattlong?.trim();

    // Do not search for empty query or lattlong.
    if ((query != null && query.isEmpty) ||
        (lattlong != null && lattlong.isEmpty))
      throw NotFoundException('Looking for nothing!');

    String path;
    path = (query != null)
        ? '$baseUrl/location/search/?query=$query'
        : '$baseUrl/location/search/?lattlong=$lattlong';

    // Can throw SocketException.
    var response = await http.get(path);
    if (response.statusCode == 200) {
      List result = json.decode(utf8.decode(response.bodyBytes));
      result.forEach((location) => locations.add(Location.fromJson(location)));
    }

    // If empty list is returned from API server,
    // So it wasn't a valid location !
    return locations.isEmpty
        ? throw NotFoundException('No location was found!')
        : locations;
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
  /// // London on a 27th Apr 2013
  /// locationDay(woeid:44418, date: DateTime.parse(2013-4-27));
  /// // San Francisco on 30th April 2013
  /// locationDay(woeid:2487956, date: DateTime.parse(2013-4-30));
  /// ```
  Future<LocationClimate> locationDay({
    @required int woeid,
    @required DateTime date,
  }) async {
    var response = await http.get('$baseUrl/location/$woeid/');
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return LocationClimate.fromJson(result);
    }
    throw Exception('Failed to fetch weather on this date!');
  }
}
