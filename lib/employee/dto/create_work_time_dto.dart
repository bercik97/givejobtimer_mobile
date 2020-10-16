import 'package:flutter/cupertino.dart';

class CreateWorkTimeDto {
  final String date;
  final String startTime;
  final String workplaceId;
  final int employeeId;

  CreateWorkTimeDto({
    @required this.date,
    @required this.startTime,
    @required this.workplaceId,
    @required this.employeeId,
  });

  static Map<String, dynamic> jsonEncode(CreateWorkTimeDto dto) {
    Map<String, dynamic> map = new Map();
    map['date'] = dto.date;
    map['startTime'] = dto.startTime;
    map['workplaceId'] = dto.workplaceId;
    map['employeeId'] = dto.employeeId;
    return map;
  }
}
