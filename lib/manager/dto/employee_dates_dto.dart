import 'package:flutter/cupertino.dart';

class EmployeeDatesDto {
  final String date;
  final String totalDateTime;

  EmployeeDatesDto({
    @required this.date,
    @required this.totalDateTime,
  });

  factory EmployeeDatesDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDatesDto(
      date: json['date'] as String,
      totalDateTime: json['totalDateTime'] as String,
    );
  }
}
