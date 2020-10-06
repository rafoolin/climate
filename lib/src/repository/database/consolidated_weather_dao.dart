/// Database object for [ConsolidatedWeather] model.
///
/// [ConsolidatedWeather] by nature doesn't contain [woeid] key
/// But in this Dao this key is added to the [ConsolidatedWeather] and
/// then is saved in the database.
///
/// But Why woeid is added?
/// =======================
///
/// Each [ConsolidatedWeather] is related to only one [LocationClimate]
/// and each [LocationClimate] contains 6 [ConsolidatedWeather]s.
/// So it's a one to many relationship in database.
///
///       --------------------                   -----------------------
///       |  LocationClimate | 1 <-----------> * | ConsolidatedWeather |
///       --------------------                   -----------------------
///
/// So we should add the primary key of the [LocationClimate]
/// into the [ConsolidatedWeather] table(store).
///
/// Also [ConsolidatedWeather] is unique in id and contains nothing to
/// determines which location[woeid] is this weather for,
/// So we added [woeid] to the [ConsolidatedWeather]'s fields.
///
/// Does [fromJson] and [toJson] of [ConsolidatedWeather] work?
/// ===========================================================
///
/// The value returned from the store/database contains a [woeid] key that is not
/// a [ConsolidatedWeather] field, When [fromJson] is called
/// on a json with extra key([woeid]),
/// that's gonna be OK([fromJson] doesn't care about that extra field).
/// So json is passed to it without removing this extra key.
///
/// How about [fromJson]?
/// =====================
///
/// We need to save [ConsolidatedWeather] on some special cases that the
/// weather info isn't available on the weekly info.
/// SO we search for that special day from API and call [toJson]
/// on that weather model, but for saving in to the database, we need to
/// add the [woeid] key too.
///
/// Right now, key for each item is [woeid] because we only care about
/// the most recent weather data, so we override the old one.
/// And thats why [woeid] is a good key for this scenario.

import 'package:climate/src/models/models.dart';
import 'package:climate/src/repository/repositories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sembast/sembast.dart';

class ConsolidatedWeatherDao {
  static final String storeName = 'ConsolidatedWeatherStore';
  final _store = intMapStoreFactory.store(storeName);

  /// Insert a ConsolidatedWeather to database
  Future<int> insert({@required int woeid, ConsolidatedWeather weather}) async {
    Database db = await DB.instance.database;
    Map map = weather.toJson();
    map['woeid'] = woeid;
    return await _store.add(db, map);
  }

  /// Insert a ConsolidatedWeather to database if it doesn't exist
  ///
  /// Update the current data if the key is existed
  Future<Map<String, dynamic>> insertOrUpdate(
      {@required int woeid, ConsolidatedWeather weather}) async {
    Database db = await DB.instance.database;
    Map map = weather.toJson();
    map['woeid'] = woeid;
    return await _store.record(woeid).put(db, map);
  }

  /// Update a ConsolidatedWeather from database
  Future<int> update({@required int woeid, ConsolidatedWeather weather}) async {
    Database db = await DB.instance.database;
    Map<String, dynamic> map = weather.toJson();
    map['woeid'] = woeid;
    return await _store.update(
      db,
      map,
      finder: Finder(filter: Filter.byKey(woeid)),
    );
  }

  /// Delete a ConsolidatedWeather from database
  Future<int> delete({@required int woeid}) async {
    Database db = await DB.instance.database;
    return await _store.delete(
      db,
      finder: Finder(filter: Filter.byKey(woeid)),
    );
  }

  /// Return most recent updates on [woeid]'s weather info in [date]
  Future<ConsolidatedWeather> locationDay({
    @required int woeid,
    @required DateTime date,
  }) async {
    Database db = await DB.instance.database;
    var result = await _store.findFirst(
      db,
      finder: Finder(
        filter: Filter.custom((snapshot) {
          int _woeid = snapshot['woeid'] as int;
          // Dates in [YYY-MM_-dd] format
          String dbDateStr = snapshot['applicable_date'] as String;
          String dateStr = DateFormat('y-MM-dd').format(date);
          return _woeid == woeid && (dateStr.compareTo(dbDateStr) == 0);
        }),
      ),
    );
    return (result != null) ? ConsolidatedWeather.fromJson(result.value) : null;
  }

  /// Clear weather store
  Future<int> clear() async {
    Database db = await DB.instance.database;
    return await _store.delete(db);
  }
}
