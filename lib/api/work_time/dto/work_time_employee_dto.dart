import 'package:flutter/cupertino.dart';

class WorkTimeEmployeeDto {
  final String date;
  final String startTime;
  final String endTime;
  final String totalTime;
  final String employeeInfo;

  WorkTimeEmployeeDto({
    @required this.date,
    @required this.startTime,
    @required this.endTime,
    @required this.totalTime,
    @required this.employeeInfo,
  });

  factory WorkTimeEmployeeDto.fromJson(Map<String, dynamic> json) {
    return WorkTimeEmployeeDto(
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      totalTime: json['totalTime'] as String,
      employeeInfo: json['employeeInfo'] as String,
    );
  }
}
