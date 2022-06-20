import 'package:fourth_year/network/entity/ticket_entity.dart';

class TravellerEntity {
  String fullname;

  String userName;

  String email;

  String password;

  int phone_number;

  List <TicketEntity> tickets = [];

  String? _token ;

  String ? _id;

  TravellerEntity({
    required this.fullname,
    required this.userName,
    required this.email,
    required this.password,
    required this.phone_number,
  });

  factory TravellerEntity.fromJson(Map<String, dynamic> json) =>
      TravellerEntity(
        fullname: json['fullname'],
        userName: json['username'],
        email: json['email'],
        password: json['password'],
        phone_number: json['phonenumber'],
      );

  Map<String, dynamic> toJson(TravellerEntity travellerEntity) =>
      <String, dynamic>{
        'fullname': travellerEntity.fullname,
        'username': travellerEntity.userName,
        'email': travellerEntity.email,
        'password': travellerEntity.password,
        'phonenumber': travellerEntity.phone_number,
      };
}
