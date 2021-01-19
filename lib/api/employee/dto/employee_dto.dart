import 'package:flutter/cupertino.dart';

class EmployeeDto {
  final int employeeId;
  final String loginCode;
  final String name;
  final String surname;
  final String nationality;
  final String timeWorkedToday;
  final String workStatus;
  final String workplace;
  final String workplaceCode;
  final String phone;
  final String viber;
  final String whatsApp;

  EmployeeDto({
    @required this.employeeId,
    @required this.loginCode,
    @required this.name,
    @required this.surname,
    @required this.nationality,
    @required this.timeWorkedToday,
    @required this.workStatus,
    @required this.workplace,
    @required this.workplaceCode,
    @required this.phone,
    @required this.viber,
    @required this.whatsApp,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      employeeId: json['employeeId'] as int,
      loginCode: json['loginCode'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      nationality: json['nationality'] as String,
      timeWorkedToday: json['timeWorkedToday'] as String,
      workStatus: json['workStatus'] as String,
      workplace: json['workplace'] as String,
      workplaceCode: json['workplaceCode'] as String,
      phone: json['phone'] as String,
      viber: json['viber'] as String,
      whatsApp: json['whatsApp'] as String,
    );
  }
}
