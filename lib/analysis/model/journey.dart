import 'package:latlong2/latlong.dart';

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
  double? distanceInMeters;
  final int timeInMinutes;

  Journey({
    required this.timestampStart,
    required this.timestampEnd,
    required this.bikeNumber,
    required this.stationStart,
    required this.stationEnd,
  }) : timeInMinutes = timestampEnd.difference(timestampStart).inMinutes;

  void setLocation({
    required String startLocationLat,
    required String startLocationLon,
    required String endLocationLat,
    required String endLocationLon,
  }) {
    this.startLocationLat = startLocationLat;
    this.startLocationLon = startLocationLon;
    this.endLocationLat = endLocationLat;
    this.endLocationLon = endLocationLon;
    distanceInMeters = Distance().as(
        LengthUnit.Meter,
        LatLng(
          double.parse(startLocationLat),
          double.parse(startLocationLon),
        ),
        LatLng(
          double.parse(endLocationLat),
          double.parse(endLocationLon),
        ));
  }

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
        'distanceInMeters': distanceInMeters,
        'timeInMinutes': timeInMinutes,
      };
}
