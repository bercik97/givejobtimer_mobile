import 'package:flutter/cupertino.dart';

class WorkplaceDto {
  final String id;
  final String name;
  final String totalTimeWorked;

  WorkplaceDto({
    @required this.id,
    @required this.name,
    @required this.totalTimeWorked,
  });

  factory WorkplaceDto.fromJson(Map<String, dynamic> json) {
    return WorkplaceDto(
      id: json['id'] as String,
      name: json['name'] as String,
      totalTimeWorked: json['totalTimeWorked'] as String,
    );
  }
}
