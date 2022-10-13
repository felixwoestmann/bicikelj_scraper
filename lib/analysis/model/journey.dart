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

  Map<String, dynamic> toMapForDB() => {
        'timestampStart': timestampStart.toString(),
        'timestampEnd': timestampEnd.toString(),
        'bikeNumber': bikeNumber,
        'stationStart': stationStart,
        'stationEnd': stationEnd,
        'startLocationLat': startLocationLat,
        'startLocationLon': startLocationLon,
        'endLocationLat': endLocationLat,
        'endLocationLon': endLocationLon,
      };
}
