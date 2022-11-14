class Position {
  final String lat;
  final String lng;

  Position.fromJson(Map<String, dynamic> json)
      : lat = json['latitude'].toString(),
        lng = json['longitude'].toString();
}
