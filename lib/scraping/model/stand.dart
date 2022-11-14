class Stand {
  final int capacity;
  final int bikes;
  final int stands;
  final int? mechanicalBikes;
  final int? electricalBikes;
  final int? electricalInternalBatteryBikes;
  final int? electricalRemovableBatteryBikes;

  Stand.fromJson(Map<String, dynamic> json)
      : capacity = json['capacity'],
        bikes = json['availabilities']['bikes'],
        stands = json['availabilities']['stands'],
        mechanicalBikes = json['availabilities']['mechanical_bikes'],
        electricalBikes = json['availabilities']['electrical_bikes'],
        electricalInternalBatteryBikes = json['availabilities']['electrical_internal_battery_bikes'],
        electricalRemovableBatteryBikes = json['availabilities']['electrical_removable_battery_bikes'];

  @override
  String toString() {
    return 'Stand{capacity: $capacity, bikes: $bikes, stands: $stands, mechanicalBikes: $mechanicalBikes, electricalBikes: $electricalBikes, electricalInternalBatteryBikes: $electricalInternalBatteryBikes, electricalRemovableBatteryBikes: $electricalRemovableBatteryBikes}';
  }

  bool get hasNullValues =>
      mechanicalBikes == null ||
      electricalBikes == null ||
      electricalInternalBatteryBikes == null ||
      electricalRemovableBatteryBikes == null;
}
