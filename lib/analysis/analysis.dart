import 'package:bicikelj_parser/analysis/model/bike_obervation.dart';
import 'package:bicikelj_parser/analysis/model/journey.dart';
import 'package:bicikelj_parser/observations_db.dart';
import 'package:collection/collection.dart';

void main() async {
  await loadDataFromDB();
}

Future<void> loadDataFromDB() async {
  final db = ObservationsDB();
  await db.createConnectionToDB('/Users/felix/Desktop/bike_observations.db');
/*  final uniqueBikeNumbers = await db.getAllUniqueBikeNumbers();
  for (final bikeNumber in uniqueBikeNumbers) {
    final observations = await db.getAllObservationsForSingleBike(bikeNumber);
    print('Bike $bikeNumber has ${observations.length} observations');
  }*/
  final observations = await db.getAllObservationsForSingleBike(996);
  observations.forEach(print);
  final chunks = createChunksForSingleBikeData(observations);
  print('There are  ${chunks.length} chunks');
  // for i loop to always take two chunks
  List<Journey> journeys = createJourneysFromChunks(chunks);
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
