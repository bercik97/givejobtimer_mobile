import 'package:flutter/cupertino.dart';

class EmployeeWorkTimeDto {
  final String startTime;
  final String endTime;
  final String totalTime;
  final String employeeInfo;

  EmployeeWorkTimeDto({
    @required this.startTime,
    @required this.endTime,
    @required this.totalTime,
    @required this.employeeInfo,
  });

  factory EmployeeWorkTimeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeWorkTimeDto(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      totalTime: json['totalTime'] as String,
      employeeInfo: json['employeeInfo'] as String,
    );
  }
}
