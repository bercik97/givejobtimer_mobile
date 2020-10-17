import 'package:flutter/cupertino.dart';

class WorkplaceDatesDto {
  final String year;
  final String month;
  final String totalDateTime;

  WorkplaceDatesDto({
    @required this.year,
    @required this.month,
    @required this.totalDateTime,
  });

  factory WorkplaceDatesDto.fromJson(Map<String, dynamic> json) {
    return WorkplaceDatesDto(
      year: json['year'] as String,
      month: json['month'] as String,
      totalDateTime: json['totalDateTime'] as String,
    );
  }
}
