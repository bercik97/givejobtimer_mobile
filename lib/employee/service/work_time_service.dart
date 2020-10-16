import 'dart:convert';
import 'dart:io';

import 'package:givejobtimer_mobile/employee/dto/create_work_time_dto.dart';
import 'package:givejobtimer_mobile/employee/dto/is_currently_at_work_with_work_times_dto.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:http/http.dart';

class WorkTimeService {
  final String authHeader;

  WorkTimeService(this.authHeader);

  static const String _url = '$SERVER_IP/work-times';

  Future<dynamic> create(CreateWorkTimeDto dto) async {
    Response res = await post(_url,
        body: jsonEncode(CreateWorkTimeDto.jsonEncode(dto)),
        headers: {
          HttpHeaders.authorizationHeader: authHeader,
          "content-type": "application/json"
        });
    return res.statusCode == 200 ? res : Future.error(res.body);
  }

  Future<IsCurrentlyAtWorkWithWorkTimesDto>
      checkIfIsCurrentlyAtWorkAndFindAllByEmployeeIdAndDateOrEndTimeIsNull(
          String employeeIdAsString, DateTime dateTime) async {
    int employeeId = int.parse(employeeIdAsString);
    String date = dateTime.toString().substring(0, 10);
    String url = _url + '/$employeeId/$date';
    Response res =
        await get(url, headers: {HttpHeaders.authorizationHeader: authHeader});
    if (res.statusCode == 200) {
      return IsCurrentlyAtWorkWithWorkTimesDto.fromJson(jsonDecode(res.body));
    } else {
      return Future.error(res.body);
    }
  }
}
