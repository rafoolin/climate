import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DB {
  static final DB _db = DB._internal();
  String _dbName = 'climate.db';
  // Only a single open connection
  Database _database;

  /// DB instance
  static DB get instance => _db;
  DB._internal();

  /// Database
  Future<Database> get database async {
    if (_database == null) _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The right directory for Android or iOS.
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, _dbName);
    return await databaseFactoryIo.openDatabase(dbPath);
  }
}
