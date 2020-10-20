import 'dart:convert';
import 'dart:io';

import 'package:givejobtimer_mobile/employee/dto/create_work_time_dto.dart';
import 'package:givejobtimer_mobile/employee/dto/employee_work_time_date_dto.dart';
import 'package:givejobtimer_mobile/employee/dto/employee_work_time_dto.dart';
import 'package:givejobtimer_mobile/employee/dto/finish_work_time_dto.dart';
import 'package:givejobtimer_mobile/employee/dto/is_currently_at_work_with_work_times_dto.dart';
import 'package:givejobtimer_mobile/manager/dto/employee_dates_dto.dart';
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
          String employeeIdAsString) async {
    int employeeId = int.parse(employeeIdAsString);
    String url = _url + '/check-if-currently-at-work/$employeeId';
    Response res =
        await get(url, headers: {HttpHeaders.authorizationHeader: authHeader});
    if (res.statusCode == 200) {
      return IsCurrentlyAtWorkWithWorkTimesDto.fromJson(jsonDecode(res.body));
    } else {
      return Future.error(res.body);
    }
  }

  Future<List<EmployeeWorkTimeDateDto>> findAllByEmployeeIdAndDateIn(
      int employeeId, String date) async {
    String url = _url + '/$employeeId/$date';
    Response res =
        await get(url, headers: {HttpHeaders.authorizationHeader: authHeader});
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => EmployeeWorkTimeDateDto.fromJson(data))
          .toList();
    } else {
      return Future.error(res.body);
    }
  }

  Future<List<EmployeeWorkTimeDto>> findAllDatesWithTotalTimeByWorkplaceId(
      String workplaceId) async {
    String url = _url + '/$workplaceId';
    Response res =
        await get(url, headers: {HttpHeaders.authorizationHeader: authHeader});
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => EmployeeWorkTimeDto.fromJson(data))
          .toList();
    } else {
      return Future.error(res.body);
    }
  }

  Future<List<EmployeeDatesDto>> findAllDatesWithTotalTimeByEmployeeId(
      int employeeId) async {
    String url = _url + '/employee/$employeeId';
    Response res =
        await get(url, headers: {HttpHeaders.authorizationHeader: authHeader});
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => EmployeeDatesDto.fromJson(data))
          .toList();
    } else {
      return Future.error(res.body);
    }
  }

  Future<dynamic> finish(FinishWorkTimeDto dto) async {
    String url = _url + '/finish';
    Response res = await put(url,
        body: jsonEncode(FinishWorkTimeDto.jsonEncode(dto)),
        headers: {
          HttpHeaders.authorizationHeader: authHeader,
          "content-type": "application/json"
        });
    return res.statusCode == 200 ? res : Future.error(res.body);
  }

  Future<dynamic> deleteByIdIn(List<int> ids) async {
    Response res = await delete(_url + '/$ids', headers: {
      HttpHeaders.authorizationHeader: authHeader,
      'content-type': 'application/json'
    });
    return res.statusCode == 200 ? res : Future.error(res.body);
  }
}
