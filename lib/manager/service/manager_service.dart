import 'dart:convert';
import 'dart:io';

import 'package:givejobtimer_mobile/manager/dto/employee_dto.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:http/http.dart';

class ManagerService {
  final String authHeader;

  ManagerService(this.authHeader);

  static const String _url = '$SERVER_IP/managers';

  Future<List<EmployeeDto>> findAllEmployees(String managerId) async {
    int id = int.parse(managerId);
    String url = _url + '/$id/employees';
    Response res =
        await get(url, headers: {HttpHeaders.authorizationHeader: authHeader});
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => EmployeeDto.fromJson(data))
          .toList();
    } else {
      return Future.error(res.body);
    }
  }
}
