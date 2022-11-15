import 'package:args/args.dart';
import 'package:bicikelj_parser/scraping/fake_browser.dart';
import 'package:bicikelj_parser/scraping/push_notification_dispatcher.dart';
import 'package:bicikelj_parser/shared/jcdecaux_api.dart';
import 'package:bicikelj_parser/shared/observations_db.dart';
import 'package:dio/dio.dart';

const output = 'output';

void main(List<String> arguments) async {
  print('Start script at ${DateTime.now().toIso8601String()}');
  final databasePath = parseDataBasePathFromArguments(arguments);
  try {
    final startTime = DateTime.now();
    print('Start querying bikes at ${startTime.toIso8601String()}');
    print('Obtaining Refresh Token...');
    final refreshToken = await FakeBrowser.obtainRefreshToken('cpr_refresh_token');
    print('Obtained refresh token: $refreshToken');
    await queryAllStationsForBikesAndStoreThemInDb(databasePath, refreshToken);
    final endTime = DateTime.now();
    print('Finished querying bikes at ${endTime.toIso8601String()}');
    print('The operation took ${endTime.difference(startTime).inSeconds} seconds');
  } catch (e) {
    print('An error occurred: $e');
    PushNotificationDispatcher.dispatchNotification(
        'An error occurred: $e', 'JRMqduFxJAPb4TppveACvzGJFgCvkzg73fjQWUPN6U');
  }
}

String parseDataBasePathFromArguments(List<String> arguments) {
  print('Parsing arguments...');
  final parser = ArgParser()..addOption(output, abbr: 'o');
  ArgResults argResults = parser.parse(arguments);
  String? dataBasePath = argResults[output];
  if (dataBasePath == null) {
    throw Exception('No output file specified. Provide with -o');
  }
  return dataBasePath;
}

Future<void> queryAllStationsForBikesAndStoreThemInDb(String dataBasePath, String refreshToken) async {
  final db = await setupDatabase(dataBasePath);
  final api = setupApi();
  String accessToken = await api.getAccessToken(refreshToken: refreshToken);
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
