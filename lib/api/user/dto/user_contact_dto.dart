import 'package:flutter/cupertino.dart';

class UserContactDto {
  final String phone;
  final String viber;
  final String whatsApp;

  UserContactDto({
    @required this.phone,
    @required this.viber,
    @required this.whatsApp,
  });

  factory UserContactDto.fromJson(Map<String, dynamic> json) {
    return UserContactDto(
      phone: json['phone'] as String,
      viber: json['viber'] as String,
      whatsApp: json['whatsApp'] as String,
    );
  }
}
