import 'dart:io';

import 'package:givejobtimer_mobile/api/employee/service/employee_service.dart';
import 'package:givejobtimer_mobile/api/user/service/user_service.dart';
import 'package:givejobtimer_mobile/api/work_time/service/work_time_service.dart';
import 'package:givejobtimer_mobile/api/workplace/service/workplace_service.dart';

class ServiceInitializer {
  static initialize(String authHeader, Object obj) {
    Map<String, String> header = {HttpHeaders.authorizationHeader: authHeader};
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: authHeader,
      "content-type": "application/json"
    };
    switch (obj.toString()) {
      case 'EmployeeService': return new EmployeeService(headers);
      case 'UserService': return new UserService(headers);
      case 'WorkplaceService': return new WorkplaceService(header, headers);
      case 'WorkTimeService': return new WorkTimeService(header, headers);
      default: throw 'Wrong (class as String) to translate!';
    }
  }
}
