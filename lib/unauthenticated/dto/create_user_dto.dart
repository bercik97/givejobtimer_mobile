import 'package:flutter/cupertino.dart';

class CreateUserDto {
  final String name;
  final String surname;
  final String nationality;
  final String phoneNumber;
  final String viberNumber;
  final String whatsAppNumber;
  final String tokenId;
  final String role;

  CreateUserDto({
    @required this.name,
    @required this.surname,
    @required this.nationality,
    @required this.phoneNumber,
    @required this.viberNumber,
    @required this.whatsAppNumber,
    @required this.tokenId,
    @required this.role,
  });

  static Map<String, dynamic> jsonEncode(CreateUserDto dto) {
    Map<String, dynamic> map = new Map();
    map['name'] = dto.name;
    map['surname'] = dto.surname;
    map['nationality'] = dto.nationality;
    map['phoneNumber'] = dto.phoneNumber;
    map['viberNumber'] = dto.viberNumber;
    map['whatsAppNumber'] = dto.whatsAppNumber;
    map['tokenId'] = dto.tokenId;
    map['role'] = dto.role;
    return map;
  }
}
