class Journey {
  final DateTime timestampStart;
  final DateTime timestampEnd;
  final int bikeNumber;
  final int stationStart;
  final int stationEnd;
  String? startLocationLat;
  String? startLocationLon;
  String? endLocationLat;
  String? endLocationLon;

  Journey({
    required this.timestampStart,
    required this.timestampEnd,
    required this.bikeNumber,
    required this.stationStart,
    required this.stationEnd,
  });
}
