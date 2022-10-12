import 'package:bicikelj_parser/model/position.dart';
import 'package:bicikelj_parser/model/stand.dart';

class Station {
  final int number;
  final String contractName;
  final String name;
  final String address;
  final Position position;
  final bool banking;
  final bool bonus;
  final String status;
  final String lastUpdated;
  final bool connected;
  final bool? overflow;
  final Stand totalStands;
  final Stand mainStands;
  final Stand? overflowStands;

  Station.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        contractName = json['contractName'],
        name = json['name'],
        address = json['address'],
        position = Position.fromJson(json['position']),
        banking = json['banking'],
        bonus = json['bonus'],
        status = json['status'],
        lastUpdated = json['lastUpdate'],
        connected = json['connected'],
        totalStands = Stand.fromJson(json['totalStands']),
        mainStands = Stand.fromJson(json['mainStands']),
        overflowStands = json['overflowStands'] != null ? Stand.fromJson(json['overflowStands']) : null,
        overflow = json['overflow'];

  @override
  String toString() {
    return 'Station{number: $number, contractName: $contractName, name: $name, address: $address, position: $position, banking: $banking, bonus: $bonus, status: $status, lastUpdated: $lastUpdated, connected: $connected, overflow: $overflow, totalStands: $totalStands, mainStands: $mainStands, overflowStands: $overflowStands}';
  }
}
