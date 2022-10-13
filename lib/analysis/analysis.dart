import 'package:bicikelj_parser/analysis/model/bike_obervation.dart';
import 'package:bicikelj_parser/analysis/model/journey.dart';
import 'package:bicikelj_parser/observations_db.dart';
import 'package:collection/collection.dart';

void main() async {
  final observationsGroupedByBike = await loadObservationsGroupedByBikeFromDB();
  List<Journey> journeysGroupedByBike = observationsGroupedByBike
      .map((obs) => createChunksForSingleBikeData(obs)) // Split Lists of Observations when Station of a Bike changes
      .map((chunks) => createJourneysFromChunks(chunks)) // Takes the generated chunks and generate journey objects
      .expand((element) => element) // flatten List<List<Journey>> to List<Journey>
      .toList();
  print('There are ${journeysGroupedByBike.length} journeys');
}

Future<List<List<BikeObservation>>> loadObservationsGroupedByBikeFromDB() async {
  final db = ObservationsDB();
  await db.createConnectionToDB('/Users/felix/Desktop/bike_observations.db');
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
