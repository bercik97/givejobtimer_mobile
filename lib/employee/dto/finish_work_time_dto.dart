import 'package:flutter/cupertino.dart';

class FinishWorkTimeDto {
  final int id;

  FinishWorkTimeDto({@required this.id});

  static Map<String, dynamic> jsonEncode(FinishWorkTimeDto dto) {
    Map<String, dynamic> map = new Map();
    map['id'] = dto.id;
    return map;
  }
}
