import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'model/bike.dart';

class ObservationsDB {
  // ignore: prefer_typing_uninitialized_variables
  late var databaseConnection;

  ObservationsDB() {
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

  Future<void> createTableBikeObservations() async {
    final tableName = 'BikeObservations';
    try {
      print('Try to create table $tableName');
      await databaseConnection.execute('''
      CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY,
          Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
          bikeId TEXT,
          stationNumber NUMBER,
          standNumber NUMBER,
          bikeNumber NUMBER
      )
      ''');
      print('Created table $tableName successfully');
    } catch (e) {
      print('Error while creating table $tableName: $e');
    }
  }

  Future<void> insertBikeIntoDB(Bike bike) async {
    try {
      await databaseConnection.insert('BikeObservations', bike.toMapForDB());
    } catch (e) {
      print('Error while inserting bike ${bike.number} into DB: $e');
    }
  }

  Future<void> closeDatabaseConnection() => databaseConnection
      .close()
      .onError((error, stackTrace) => print('Error while closing database connection: $error'));
}
