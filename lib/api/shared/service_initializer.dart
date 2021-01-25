import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/api/employee/service/employee_service.dart';
import 'package:givejobtimer_mobile/api/group/service/group_service.dart';
import 'package:givejobtimer_mobile/api/token/service/token_service.dart';
import 'package:givejobtimer_mobile/api/user/service/user_service.dart';
import 'package:givejobtimer_mobile/api/work_time/service/work_time_service.dart';
import 'package:givejobtimer_mobile/api/workplace/service/workplace_service.dart';

class ServiceInitializer {
  static initialize(BuildContext context, String authHeader, Object obj) {
    Map<String, String> header = {HttpHeaders.authorizationHeader: authHeader};
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: authHeader,
      "content-type": "application/json"
    };
    switch (obj.toString()) {
      case 'EmployeeService': return new EmployeeService(context, headers);
      case 'GroupService': return new GroupService(context, headers);
      case 'UserService': return new UserService(context, headers);
      case 'TokenService': return new TokenService();
      case 'WorkplaceService': return new WorkplaceService(context, header, headers);
      case 'WorkTimeService': return new WorkTimeService(context, header, headers);
      default: throw 'Wrong (class as String) to translate!';
    }
  }
}
