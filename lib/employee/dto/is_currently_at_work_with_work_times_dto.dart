import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/employee/dto/work_time_dto.dart';

class IsCurrentlyAtWorkWithWorkTimesDto {
  final bool currentlyAtWork;
  final List workTimes;

  IsCurrentlyAtWorkWithWorkTimesDto(
      {@required this.currentlyAtWork, @required this.workTimes});

  factory IsCurrentlyAtWorkWithWorkTimesDto.fromJson(
      Map<String, dynamic> json) {
    return IsCurrentlyAtWorkWithWorkTimesDto(
      currentlyAtWork: json['currentlyAtWork'] as bool,
      workTimes:
          json['workTimes'].map((data) => WorkTimeDto.fromJson(data)).toList(),
    );
  }
}
