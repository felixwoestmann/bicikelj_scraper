import 'package:bicikelj_parser/analysis/model/journey.dart';
import 'package:bicikelj_parser/analysis/model/journey_db.dart';
import 'package:bicikelj_parser/scraping/model/station.dart';
import 'package:bicikelj_parser/shared/bike_obervation.dart';
import 'package:bicikelj_parser/shared/jcdecaux_api.dart';
import 'package:bicikelj_parser/shared/observations_db.dart';
import 'package:collection/collection.dart';
import 'package:quiver/iterables.dart';

void main() async {
  const pathToDb = '/Users/felix/Downloads/20221201_bike_observations.db';
  final observationsGroupedByBike = await loadObservationsGroupedByBikeFromDB(pathToDb);
  List<Journey> journeysGroupedByBike = observationsGroupedByBike
      .map((obs) => createChunksForSingleBikeData(obs)) // Split Lists of Observations when Station of a Bike changes
      .map((chunks) => createJourneysFromChunks(chunks)) // Takes the generated chunks and generate journey objects
      .expand((e) => e) // flatten List<List<Journey>> to List<Journey>
      .toList();

  print('There are ${journeysGroupedByBike.length} journeys');

  final stations = await loadStationData();
  final journeysWithLocation = addLocationDataFromStationsToJourneys(journeysGroupedByBike, stations);

  print(
      'There are ${journeysWithLocation.where((element) => element.startLocationLat == null).toList().length} journeys without location data');
  print('Create connection to DB and table');

  final db = await setupDatabase('journey.db');

  for (final part in partition(journeysWithLocation, 500)) {
    await db.insertJourneyInBatches(part);
  }
}

Future<List<List<BikeObservation>>> loadObservationsGroupedByBikeFromDB(String path) async {
  final db = ObservationsDB();
  await db.createConnectionToDB(path);
  final uniqueBikeNumbers = await db.getAllUniqueBikeNumbers();
  List<Future<List<BikeObservation>>> observationsGroupedByBikes =
      uniqueBikeNumbers.map((bikeNumber) => db.getAllObservationsForSingleBike(bikeNumber)).toList();
  return await Future.wait(observationsGroupedByBikes);
}

List<List<BikeObservation>> createChunksForSingleBikeData(List<BikeObservation> observations) =>
    observations.splitBetween((first, second) => first.stationNumber != second.stationNumber).toList();

List<Journey> createJourneysFromChunks(List<List<BikeObservation>> chunks) {
  if (chunks.length < 2) {
    return [];
  }
  final journeys = <Journey>[];
  for (var i = 0; i < chunks.length - 1; i++) {
    final firstChunk = chunks[i];
    final secondChunk = chunks[i + 1];
    final firstChunkLastObservation = firstChunk.last;
    final secondChunkFirstObservation = secondChunk.first;
    journeys.add(Journey(
      bikeNumber: firstChunkLastObservation.bikeNumber,
      stationStart: firstChunkLastObservation.stationNumber,
      stationEnd: secondChunkFirstObservation.stationNumber,
      timestampStart: firstChunkLastObservation.timestamp,
      timestampEnd: secondChunkFirstObservation.timestamp,
    ));
  }
  return journeys;
}

Future<List<Station>> loadStationData() => JCDecauxAPI.setupApi().getStations();

List<Journey> addLocationDataFromStationsToJourneys(List<Journey> journeysWithOutLocation, List<Station> stations) =>
    journeysWithOutLocation.map((journey) {
      final stationStart = stations.firstWhere((station) => station.number == journey.stationStart);
      final stationEnd = stations.firstWhere((station) => station.number == journey.stationEnd);
      journey.setLocation(
          startLocationLat: stationStart.position.lat,
          startLocationLon: stationStart.position.lng,
          endLocationLat: stationEnd.position.lat,
          endLocationLon: stationEnd.position.lng);
      return journey;
    }).toList();

Future<JourneyDB> setupDatabase(String dataBasePath) async {
  final db = JourneyDB();
  await db.createConnectionToDB(dataBasePath);
  await db.createTableJourneys();
  return db;
}
