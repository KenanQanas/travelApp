class TicketEntity {
  final DateTime createdAd;

  final String from;

  final String to;

  final String flightID;

  final int credentialNumber;

  final int id;

  TicketEntity({
    required this.createdAd,
    required this.from,
    required this.to,
    required this.flightID,
    required this.credentialNumber,
    required this.id,
  });

  factory TicketEntity.fromJson(Map<String, dynamic> json) => TicketEntity(
        createdAd: DateTime.parse(json['createdAt'] as String),
        from: json['from'] as String,
        to: json['to'] as String,
        flightID: json['flightID'] as String,
        credentialNumber: json['credentialNumber'] as int,
        id: json['_id'] as int,
      );
}
