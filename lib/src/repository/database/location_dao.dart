import 'package:climate/src/models/models.dart';
import 'package:climate/src/repository/repositories.dart';
import 'package:sembast/sembast.dart';

class LocationDao {
  static final String storeName = 'LocationStore';
  final _store = intMapStoreFactory.store(storeName);

  /// Insert a Location to database
  Future<int> insert({Location location}) async {
    Database db = await DB.instance.database;
    return await _store.add(db, location.toJson());
  }

  /// Update a Location from database
  Future<int> update({int woeid, Location location}) async {
    Database db = await DB.instance.database;
    return await _store.update(
      db,
      location.toJson(),
      finder: Finder(filter: Filter.byKey(woeid)),
    );
  }

  /// Delete a Location from database
  Future<int> delete({int woeid}) async {
    Database db = await DB.instance.database;
    return await _store.delete(
      db,
      finder: Finder(filter: Filter.byKey(woeid)),
    );
  }

  Future<List<Location>> locationSearch({String query, String lattlong}) async {
    Database db = await DB.instance.database;
    var result = await _store.find(
      db,
      finder: Finder(filter: Filter.matches('title', query)),
    );

    return result.map((e) => Location.fromJson(e.value)).toList();
  }
}
