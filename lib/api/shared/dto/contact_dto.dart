import 'package:flutter/cupertino.dart';

class ContactDto {
  final String userInfo;
  final String phone;
  final String viber;
  final String whatsApp;

  ContactDto({
    @required this.userInfo,
    @required this.phone,
    @required this.viber,
    @required this.whatsApp,
  });

  factory ContactDto.fromJson(Map<String, dynamic> json) {
    return ContactDto(
      userInfo: json['userInfo'] as String,
      phone: json['phone'] as String,
      viber: json['viber'] as String,
      whatsApp: json['whatsApp'] as String,
    );
  }
}
