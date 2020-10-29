import 'dart:convert';

import 'package:givejobtimer_mobile/api/work_time/dto/create_work_time_dto.dart';
import 'package:givejobtimer_mobile/api/work_time/dto/work_time_employee_date_dto.dart';
import 'package:givejobtimer_mobile/api/work_time/dto/work_time_employee_dto.dart';
import 'package:givejobtimer_mobile/api/work_time/dto/is_currently_at_work_with_work_times_dto.dart';
import 'package:givejobtimer_mobile/api/work_time/dto/work_time_dates_dto.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:http/http.dart';

class WorkTimeService {
  final Map<String, String> _header;
  final Map<String, String> _headers;

  WorkTimeService(this._header, this._headers);

  static const String _url = '$SERVER_IP/work-times';

  Future<dynamic> create(CreateWorkTimeDto dto) async {
    Response res = await post(
      _url,
      body: jsonEncode(CreateWorkTimeDto.jsonEncode(dto)),
      headers: _headers,
    );
    return res.statusCode == 200 ? res : Future.error(res.body);
  }

  Future<List<WorkTimeEmployeeDto>> findAllDatesWithTotalTimeByWorkplaceId(
      String workplaceId) async {
    String url = _url + '?workplace_id=$workplaceId';
    Response res = await get(url, headers: _header);
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => WorkTimeEmployeeDto.fromJson(data))
            .toList()
        : Future.error(res.body);
  }

  Future<List<WorkTimeDateEmployeeDto>> findAllByEmployeeIdAndDateIn(
      int employeeId, String date) async {
    String url = _url + '/employees?employee_id=$employeeId&date=$date';
    Response res = await get(url, headers: _header);
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => WorkTimeDateEmployeeDto.fromJson(data))
            .toList()
        : Future.error(res.body);
  }

  Future<List<WorkTimeDatesDto>> findAllDatesWithTotalTimeByEmployeeId(
      int employeeId) async {
    String url = _url + '/total-date-time?employee_id=$employeeId';
    Response res = await get(url, headers: _header);
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => WorkTimeDatesDto.fromJson(data))
            .toList()
        : Future.error(res.body);
  }

  Future<IsCurrentlyAtWorkWithWorkTimesDto>
      checkIfIsCurrentlyAtWorkAndFindAllByEmployeeIdAndDateOrEndTimeIsNull(
          String employeeIdAsString) async {
    int employeeId = int.parse(employeeIdAsString);
    String url = _url + '/currently-at-work?employee_id=$employeeId';
    Response res = await get(url, headers: _header);
    return res.statusCode == 200
        ? IsCurrentlyAtWorkWithWorkTimesDto.fromJson(jsonDecode(res.body))
        : Future.error(res.body);
  }

  Future<dynamic> finish(int id) async {
    String url = _url + '/finish?id=$id';
    Response res = await put(url, headers: _headers);
    return res.statusCode == 200 ? res : Future.error(res.body);
  }

  Future<dynamic> deleteByIdIn(List<int> ids) async {
    Response res = await delete(_url + '/$ids', headers: _headers);
    return res.statusCode == 200 ? res : Future.error(res.body);
  }
}
