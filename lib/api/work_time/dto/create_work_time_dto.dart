import 'package:flutter/cupertino.dart';

class CreateWorkTimeDto {
  final String workplaceId;
  final int employeeId;

  CreateWorkTimeDto({@required this.workplaceId, @required this.employeeId});

  static Map<String, dynamic> jsonEncode(CreateWorkTimeDto dto) {
    Map<String, dynamic> map = new Map();
    map['workplaceId'] = dto.workplaceId;
    map['employeeId'] = dto.employeeId;
    return map;
  }
}
