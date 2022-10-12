import 'package:bicikelj_parser/jcdecaux_api.dart';
import 'package:bicikelj_parser/observations_db.dart';
import 'package:dio/dio.dart';

void main() async {
  final startTime = DateTime.now();
  print('Start querying bikes at ${startTime.toIso8601String()}');
  await queryAllStationsForBikesAndStoreThemInDb();
  final endTime = DateTime.now();
  print('Finished querying bikes at ${endTime.toIso8601String()}');
  print('The operation took ${endTime.difference(startTime).inSeconds} seconds');
}

Future<void> queryAllStationsForBikesAndStoreThemInDb() async {
  final db = await setupDatabase();
  final api = setupApi();
  String accessToken = await api.getAccessToken(refreshToken: '0473a366-c216-4fec-a559-cab46e6a37e9');
  final stations = await api.getStations();
  print('Found ${stations.length} stations');
  List<Future<void>> fetchAndStoreBikeOperations = [];
  for (var station in stations) {
    fetchAndStoreBikeOperations.add(api
        .getBikesAtStation(stationNumber: station.number, accessToken: accessToken)
        .then((bikes) => bikes.forEach(db.insertBikeIntoDB)));
  }
  await Future.wait(fetchAndStoreBikeOperations);
}

Future<ObservationsDB> setupDatabase() async {
  final db = ObservationsDB();
  await db.createConnectionToDB();
  await db.createTableBikeObservations();
  return db;
}

JCDecauxAPI setupApi() {
  const String apiKey = 'd14e5c3e8f5ddb62e49354b321294d20b137e143';
  const String contract = 'Ljubljana';
  final api = JCDecauxAPI(apiKey: apiKey, contract: contract, dio: Dio());
  return api;
}
