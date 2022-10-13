class BikeObservation {
  final DateTime timestamp;
  final int bikeNumber;
  final int stationNumber;
  final int standNumber;

  BikeObservation(
    this.timestamp,
    this.bikeNumber,
    this.stationNumber,
    this.standNumber,
  );

  BikeObservation.fromMap(Map<String, dynamic> map)
      : timestamp = DateTime.parse(map['Timestamp']),
        bikeNumber = map['bikeNumber'],
        stationNumber = map['stationNumber'],
        standNumber = map['standNumber'];

  @override
  String toString() {
    return 'BikeObservation{timestamp: $timestamp, bikeNumber: $bikeNumber, stationNumber: $stationNumber, standNumber: $standNumber}';
  }
}
