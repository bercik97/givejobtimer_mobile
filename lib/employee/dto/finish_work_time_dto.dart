import 'package:flutter/cupertino.dart';

class FinishWorkTimeDto {
  final int id;
  final String endTime;

  FinishWorkTimeDto({
    @required this.id,
    @required this.endTime,
  });

  static Map<String, dynamic> jsonEncode(FinishWorkTimeDto dto) {
    Map<String, dynamic> map = new Map();
    map['id'] = dto.id;
    map['endTime'] = dto.endTime;
    return map;
  }
}
