import 'package:flutter/cupertino.dart';

class CreateWorkplaceDto {
  final int managerId;
  final String name;

  CreateWorkplaceDto({
    @required this.managerId,
    @required this.name,
  });

  static Map<String, dynamic> jsonEncode(CreateWorkplaceDto dto) {
    Map<String, dynamic> map = new Map();
    map['managerId'] = dto.managerId;
    map['name'] = dto.name;
    return map;
  }
}
