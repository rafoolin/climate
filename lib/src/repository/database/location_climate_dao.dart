import 'package:climate/src/models/models.dart';
import 'package:climate/src/repository/repositories.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

class LocationClimateDao {
  static final String storeName = 'LocationClimateStore';
  final _store = intMapStoreFactory.store(storeName);

  /// Insert a LocationClimate to database
  Future<int> insert({LocationClimate climate}) async {
    Database db = await DB.instance.database;
    return await _store.add(db, climate.toJson());
  }

  /// Insert a LocationClimate to database if it doesn't exist
  ///
  /// Update the current data if the key is existed
  Future<Map<String, dynamic>> insertOrUpdate({LocationClimate climate}) async {
    Database db = await DB.instance.database;
    return await _store.record(climate.woeid).put(db, climate.toJson());
  }

  /// Update a LocationClimate from database
  Future<int> update({int woeid, LocationClimate climate}) async {
    Database db = await DB.instance.database;
    return await _store.update(
      db,
      climate.toJson(),
      finder: Finder(filter: Filter.byKey(woeid)),
    );
  }

  /// Delete a LocationClimate from database
  Future<int> delete({int woeid}) async {
    Database db = await DB.instance.database;
    return await _store.delete(
      db,
      finder: Finder(filter: Filter.byKey(woeid)),
    );
  }

  Future<LocationClimate> location({@required int woeid}) async {
    Database db = await DB.instance.database;
    var result = await _store.findFirst(
      db,
      finder: Finder(filter: Filter.equals('woeid', woeid)),
    );
    if (result != null) return LocationClimate.fromJson(result.value);
    return null;
  }

  /// Clear climate store
  Future<int> clear() async {
    Database db = await DB.instance.database;
    return await _store.delete(db);
  }
}
