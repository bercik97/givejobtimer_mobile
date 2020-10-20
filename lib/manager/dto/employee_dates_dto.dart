import 'package:flutter/cupertino.dart';

class EmployeeDatesDto {
  final String year;
  final String month;
  final String totalDateTime;

  EmployeeDatesDto({
    @required this.year,
    @required this.month,
    @required this.totalDateTime,
  });

  factory EmployeeDatesDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDatesDto(
      year: json['year'] as String,
      month: json['month'] as String,
      totalDateTime: json['totalDateTime'] as String,
    );
  }
}
