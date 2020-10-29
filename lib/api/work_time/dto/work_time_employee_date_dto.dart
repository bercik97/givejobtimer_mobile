import 'package:flutter/cupertino.dart';

class WorkTimeDateEmployeeDto {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final String totalTime;
  final String workplaceId;

  WorkTimeDateEmployeeDto({
    @required this.id,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
    @required this.totalTime,
    @required this.workplaceId,
  });

  factory WorkTimeDateEmployeeDto.fromJson(Map<String, dynamic> json) {
    return WorkTimeDateEmployeeDto(
      id: json['id'] as int,
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      totalTime: json['totalTime'] as String,
      workplaceId: json['workplaceId'] as String,
    );
  }
}
