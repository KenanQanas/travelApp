class FlightEntity {
  final String id;

  final String from;

  final String to;

  final int price;

  final DateTime flightDate;

  final DateTime createdAt;

  final DateTime updatedAd;

  final int v;

  FlightEntity({
    required this.id,
    required this.from,
    required this.to,
    required this.price,
    required this.flightDate,
    required this.createdAt,
    required this.updatedAd,
    required this.v,
  });

  factory FlightEntity.fromJson(Map<String, dynamic> json) => FlightEntity(
        id: json['_id'] as String,
        from: json['from'] as String,
        to: json['to'] as String,
        price: json['price'] as int,
        flightDate: DateTime.parse(json['flightDate'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAd: DateTime.parse(json['updatedAd'] as String),
        v: json['__v'] as int,
      );
}
