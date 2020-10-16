import 'package:flutter/cupertino.dart';

class WorkplaceDto {
  final String id;
  final String name;

  WorkplaceDto({
    @required this.id,
    @required this.name,
  });

  factory WorkplaceDto.fromJson(Map<String, dynamic> json) {
    return WorkplaceDto(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
