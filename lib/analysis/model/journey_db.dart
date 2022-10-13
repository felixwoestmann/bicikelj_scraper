import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'journey.dart';

class JourneyDB {
  // ignore: prefer_typing_uninitialized_variables
  late var databaseConnection;

  JourneyDB() {
    sqfliteFfiInit();
  }

  Future<void> createConnectionToDB(String databasePath) async {
    try {
      print('Try to create a connection to Database $databasePath');
      databaseConnection = await databaseFactoryFfi.openDatabase(databasePath);
      print('Created Database connection successfully. Stored at ${databaseConnection.path}');
    } catch (e) {
      print('Error while creating database: $e');
    }
  }

  Future<void> createTableJourneys() async {
    final tableName = 'Journeys';
    try {
      print('Try to create table $tableName');
      await databaseConnection.execute('''
      CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY,
          timestampStart DATETIME,
          timestampEnd DATETIME,
          bikeNumber NUMBER,
          stationStart NUMBER,
          stationEnd NUMBER,
          startLocationLat TEXT,
          startLocationLon TEXT,
          endLocationLat TEXT,
          endLocationLon TEXT
      )
      ''');
      print('Created table $tableName successfully');
    } catch (e) {
      print('Error while creating table $tableName: $e');
    }
  }

  Future<void> insertJourneyIntoDB(Journey journey) async {
    try {
      await databaseConnection.insert('Journeys', journey.toMapForDB());
    } catch (e) {
      print('Error while inserting journey from ${journey.stationStart} to ${journey.stationEnd} into DB: $e');
    }
  }

  Future<void> closeDatabaseConnection() => databaseConnection
      .close()
      .onError((error, stackTrace) => print('Error while closing database connection: $error'));
}
