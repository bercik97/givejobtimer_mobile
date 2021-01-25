import 'package:flutter/cupertino.dart';

class CreateWorkplaceDto {
  final int companyId;
  final String name;

  CreateWorkplaceDto({
    @required this.companyId,
    @required this.name,
  });

  static Map<String, dynamic> jsonEncode(CreateWorkplaceDto dto) {
    Map<String, dynamic> map = new Map();
    map['companyId'] = dto.companyId;
    map['name'] = dto.name;
    return map;
  }
}
