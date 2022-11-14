class Rating {
  final double? value;
  final int? count;
  final String? lastRatingDateTime;

  Rating.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        count = json['count'],
        lastRatingDateTime = json['lastRatingDateTime'];
}
