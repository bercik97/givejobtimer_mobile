import 'package:flutter/cupertino.dart';

class WorkTimeDatesDto {
  final String year;
  final String month;
  final String totalDateTime;

  WorkTimeDatesDto({
    @required this.year,
    @required this.month,
    @required this.totalDateTime,
  });

  factory WorkTimeDatesDto.fromJson(Map<String, dynamic> json) {
    return WorkTimeDatesDto(
      year: json['year'] as String,
      month: json['month'] as String,
      totalDateTime: json['totalDateTime'] as String,
    );
  }
}
