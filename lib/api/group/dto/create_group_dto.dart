import 'package:flutter/cupertino.dart';

class CreateGroupDto {
  final String name;
  final String description;
  final num companyId;
  final List<String> employeeIds;

  CreateGroupDto({
    @required this.name,
    @required this.description,
    @required this.companyId,
    @required this.employeeIds,
  });

  static Map<String, dynamic> jsonEncode(CreateGroupDto dto) {
    Map<String, dynamic> map = new Map();
    map['name'] = dto.name;
    map['description'] = dto.description;
    map['companyId'] = dto.companyId;
    map['employeeIds'] = dto.employeeIds;
    return map;
  }
}
