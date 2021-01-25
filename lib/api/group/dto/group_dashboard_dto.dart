import 'package:flutter/cupertino.dart';

class GroupDashboardDto {
  final num id;
  final String name;
  final String description;
  final int numberOfEmployees;

  GroupDashboardDto({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.numberOfEmployees,
  });

  factory GroupDashboardDto.fromJson(Map<String, dynamic> json) {
    return GroupDashboardDto(
      id: json['id'] as num,
      name: json['name'] as String,
      description: json['description'] as String,
      numberOfEmployees: json['numberOfEmployees'] as int,
    );
  }
}
