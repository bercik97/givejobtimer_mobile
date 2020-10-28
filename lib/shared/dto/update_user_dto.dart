import 'package:flutter/cupertino.dart';

class UpdateUserDto {
  final String name;
  final String surname;
  final String nationality;
  final String phone;
  final String viber;
  final String whatsApp;

  UpdateUserDto({
    @required this.name,
    @required this.surname,
    @required this.nationality,
    @required this.phone,
    @required this.viber,
    @required this.whatsApp,
  });

  static Map<String, dynamic> jsonEncode(UpdateUserDto dto) {
    Map<String, dynamic> map = new Map();
    map['name'] = dto.name;
    map['surname'] = dto.surname;
    map['nationality'] = dto.nationality;
    map['phone'] = dto.phone;
    map['viber'] = dto.viber;
    map['whatsApp'] = dto.whatsApp;
    return map;
  }
}
