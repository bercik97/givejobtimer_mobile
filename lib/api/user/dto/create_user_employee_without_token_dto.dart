import 'package:flutter/cupertino.dart';

class CreateUserEmployeeWithoutTokenDto {
  final String name;
  final String surname;
  final String nationality;
  final num companyId;

  CreateUserEmployeeWithoutTokenDto({
    @required this.name,
    @required this.surname,
    @required this.nationality,
    @required this.companyId,
  });

  static Map<String, dynamic> jsonEncode(CreateUserEmployeeWithoutTokenDto dto) {
    Map<String, dynamic> map = new Map();
    map['name'] = dto.name;
    map['surname'] = dto.surname;
    map['nationality'] = dto.nationality;
    map['companyId'] = dto.companyId;
    return map;
  }
}
