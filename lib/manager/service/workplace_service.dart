import 'dart:convert';
import 'dart:io';

import 'package:givejobtimer_mobile/manager/dto/create_workplace_dto.dart';
import 'package:givejobtimer_mobile/manager/dto/update_workplace_dto.dart';
import 'package:givejobtimer_mobile/manager/dto/workplace_dto.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:http/http.dart';

class WorkplaceService {
  final String authHeader;

  WorkplaceService(this.authHeader);

  static const String _url = '$SERVER_IP/workplaces';

  Future<String> create(CreateWorkplaceDto dto) async {
    Response res = await post(_url,
        body: jsonEncode(CreateWorkplaceDto.jsonEncode(dto)),
        headers: {
          HttpHeaders.authorizationHeader: authHeader,
          "content-type": "application/json"
        });
    return res.statusCode == 200 ? res.body.toString() : Future.error(res.body);
  }

  Future<List<WorkplaceDto>> findAllByManagerId(String managerId) async {
    int id = int.parse(managerId);
    String url = _url + '/$id';
    Response res =
        await get(url, headers: {HttpHeaders.authorizationHeader: authHeader});
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => WorkplaceDto.fromJson(data))
          .toList();
    } else {
      return Future.error(res.body);
    }
  }

  Future<dynamic> deleteByIdIn(List<String> ids) async {
    Response res = await delete(_url + '/$ids', headers: {
      HttpHeaders.authorizationHeader: authHeader,
      'content-type': 'application/json'
    });
    return res.statusCode == 200 ? res : Future.error(res.body);
  }

  Future<dynamic> update(UpdateWorkplaceDto dto) async {
    Response res = await put(_url,
        body: jsonEncode(UpdateWorkplaceDto.jsonEncode(dto)),
        headers: {
          HttpHeaders.authorizationHeader: authHeader,
          'content-type': 'application/json'
        });
    return res.statusCode == 200 ? res : Future.error(res.body);
  }
}
