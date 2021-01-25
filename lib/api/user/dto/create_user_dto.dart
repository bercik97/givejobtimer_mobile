import 'package:flutter/cupertino.dart';

class CreateUserDto {
  final String name;
  final String surname;
  final String nationality;
  final String phone;
  final String viber;
  final String whatsApp;
  final String tokenId;
  final num companyId;
  final String role;

  CreateUserDto({
    @required this.name,
    @required this.surname,
    @required this.nationality,
    @required this.phone,
    @required this.viber,
    @required this.whatsApp,
    @required this.tokenId,
    @required this.companyId,
    @required this.role,
  });

  static Map<String, dynamic> jsonEncode(CreateUserDto dto) {
    Map<String, dynamic> map = new Map();
    map['name'] = dto.name;
    map['surname'] = dto.surname;
    map['nationality'] = dto.nationality;
    map['phone'] = dto.phone;
    map['viber'] = dto.viber;
    map['whatsApp'] = dto.whatsApp;
    map['tokenId'] = dto.tokenId;
    map['companyId'] = dto.companyId;
    map['role'] = dto.role;
    return map;
  }
}
