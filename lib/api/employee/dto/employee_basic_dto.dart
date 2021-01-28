import 'package:flutter/cupertino.dart';

class EmployeeBasicDto {
  final int id;
  final String name;
  final String surname;
  final String nationality;
  final String loginCode;

  EmployeeBasicDto({
    @required this.id,
    @required this.name,
    @required this.surname,
    @required this.nationality,
    @required this.loginCode,
  });

  factory EmployeeBasicDto.fromJson(Map<String, dynamic> json) {
    return EmployeeBasicDto(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      nationality: json['nationality'] as String,
      loginCode: json['loginCode'] as String,
    );
  }
}
