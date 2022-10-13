import 'package:args/args.dart';
import 'package:bicikelj_parser/jcdecaux_api.dart';
import 'package:bicikelj_parser/observations_db.dart';
import 'package:dio/dio.dart';

const output = 'output';

void main(List<String> arguments) async {
  print('Parsing arguments...');
  final parser = ArgParser()..addOption(output, abbr: 'o');
  ArgResults argResults = parser.parse(arguments);
  String? dataBasePath = argResults[output];
  if (dataBasePath == null) {
    print('No output file specified. Provide with -o');
    return;
  }
  final startTime = DateTime.now();
  print('Start querying bikes at ${startTime.toIso8601String()}');
  await queryAllStationsForBikesAndStoreThemInDb(dataBasePath);
  final endTime = DateTime.now();
  print('Finished querying bikes at ${endTime.toIso8601String()}');
  print('The operation took ${endTime.difference(startTime).inSeconds} seconds');
}

Future<void> queryAllStationsForBikesAndStoreThemInDb(String dataBasePath) async {
  final db = await setupDatabase(dataBasePath);
  final api = setupApi();
  String accessToken = await api.getAccessToken(refreshToken: 'eb9eec19-7929-4b53-a68a-24d9cedfa652');
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

Future<ObservationsDB> setupDatabase(String dataBasePath) async {
  final db = ObservationsDB();
  await db.createConnectionToDB(dataBasePath);
  await db.createTableBikeObservations();
  return db;
}

JCDecauxAPI setupApi() {
  const String apiKey = 'd14e5c3e8f5ddb62e49354b321294d20b137e143';
  const String contract = 'Ljubljana';
  final api = JCDecauxAPI(apiKey: apiKey, contract: contract, dio: Dio());
  return api;
}
