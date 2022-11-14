import 'package:bicikelj_parser/shared/rating.dart';

class Bike {
  final String id;
  final int number;
  final String contractName;
  final String type;
  final int stationNumber;
  final int standNumber;
  final String status;
  final bool hasBattery;
  final bool hasLock;
  final Rating rating;
  final bool checked;
  final String createdAt;
  final String updatedAt;

  Bike.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        number = json['number'],
        contractName = json['contractName'],
        type = json['type'],
        stationNumber = json['stationNumber'],
        standNumber = json['standNumber'],
        status = json['status'],
        hasBattery = json['hasBattery'],
        hasLock = json['hasLock'],
        rating = Rating.fromJson(json['rating']),
        checked = json['checked'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toMapForDB() => {
        'bikeId': id,
        'bikeNumber': number,
        'stationNumber': stationNumber,
        'standNumber': standNumber,
      };
}
