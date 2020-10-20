import 'package:flutter/cupertino.dart';

class EmployeeWorkTimeDateDto {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final String totalTime;
  final String workplaceId;

  EmployeeWorkTimeDateDto({
    @required this.id,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
    @required this.totalTime,
    @required this.workplaceId,
  });

  factory EmployeeWorkTimeDateDto.fromJson(Map<String, dynamic> json) {
    return EmployeeWorkTimeDateDto(
      id: json['id'] as int,
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      totalTime: json['totalTime'] as String,
      workplaceId: json['workplaceId'] as String,
    );
  }
}
