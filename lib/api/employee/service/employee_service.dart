import 'dart:convert';

import 'package:givejobtimer_mobile/api/employee/dto/employee_dto.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:http/http.dart';

class EmployeeService {
  final Map<String, String> _header;

  EmployeeService(this._header);

  static const String _url = '$SERVER_IP/employees';

  Future<List<EmployeeDto>> findAllByManagerId(String managerId) async {
    int id = int.parse(managerId);
    String url = _url + '?manager_id=$id';
    Response res = await get(
      url,
      headers: _header,
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => EmployeeDto.fromJson(data))
            .toList()
        : Future.error(res.body);
  }
}
