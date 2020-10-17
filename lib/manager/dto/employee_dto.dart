import 'package:flutter/cupertino.dart';

class EmployeeDto {
  final int employeeId;
  final String name;
  final String surname;
  final String nationality;
  final String timeWorkedToday;
  final String phone;
  final String viber;
  final String whatsApp;

  EmployeeDto({
    @required this.employeeId,
    @required this.name,
    @required this.surname,
    @required this.nationality,
    @required this.timeWorkedToday,
    @required this.phone,
    @required this.viber,
    @required this.whatsApp,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      employeeId: json['employeeId'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      nationality: json['nationality'] as String,
      timeWorkedToday: json['timeWorkedToday'] as String,
      phone: json['phone'] as String,
      viber: json['viber'] as String,
      whatsApp: json['whatsApp'] as String,
    );
  }
}
