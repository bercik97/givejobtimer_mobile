import 'dart:convert';

import 'package:givejobtimer_mobile/api/workplace/dto/create_workplace_dto.dart';
import 'package:givejobtimer_mobile/api/workplace/dto/workplace_dates_dto.dart';
import 'package:givejobtimer_mobile/api/workplace/dto/workplace_dto.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:http/http.dart';

class WorkplaceService {
  final Map<String, String> _header;
  final Map<String, String> _headers;

  WorkplaceService(this._header, this._headers);

  static const String _url = '$SERVER_IP/workplaces';

  Future<String> create(CreateWorkplaceDto dto) async {
    Response res = await post(
      _url,
      body: jsonEncode(CreateWorkplaceDto.jsonEncode(dto)),
      headers: _headers,
    );
    return res.statusCode == 200 ? res.body.toString() : Future.error(res.body);
  }

  Future<bool> isCorrectByIdAndManagerId(String id, String managerId) async {
    int managerIdAsInt = int.parse(managerId);
    String url = _url + '/correct?id=$id&manager_id=$managerIdAsInt';
    Response res = await get(url, headers: _header);
    return res.statusCode == 200 ? res.body == 'true' : false;
  }

  Future<List<WorkplaceDto>> findAllByManagerId(String managerId) async {
    int id = int.parse(managerId);
    String url = _url + '?manager_id=$id';
    Response res = await get(url, headers: _header);
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => WorkplaceDto.fromJson(data))
            .toList()
        : Future.error(res.body);
  }

  Future<List<WorkplaceDatesDto>> findAllDatesWithTotalTimeByWorkplaceId(
      String workplaceId) async {
    String url = _url + '/$workplaceId';
    Response res = await get(url, headers: _header);
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => WorkplaceDatesDto.fromJson(data))
            .toList()
        : Future.error(res.body);
  }

  Future<dynamic> update(String id, Map<String, Object> fieldsValues) async {
    Response res = await put(
      _url + '?id=$id',
      body: jsonEncode(fieldsValues),
      headers: _headers,
    );
    return res.statusCode == 200 ? res : Future.error(res.body);
  }

  Future<dynamic> deleteByIdIn(List<String> ids) async {
    Response res = await delete(
      _url + '/$ids',
      headers: _headers,
    );
    return res.statusCode == 200 ? res : Future.error(res.body);
  }
}
