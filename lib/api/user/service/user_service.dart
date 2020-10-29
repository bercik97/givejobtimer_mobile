import 'dart:convert';

import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/api/user/dto/create_user_dto.dart';
import 'package:http/http.dart';

class UserService {
  final Map<String, String> _headers;

  UserService(this._headers);

  static const String _url = '$SERVER_IP/users';

  Future<dynamic> create(CreateUserDto dto) async {
    Response res = await post(
      _url,
      body: jsonEncode(CreateUserDto.jsonEncode(dto)),
      headers: {"content-type": "application/json"},
    );
    return res.statusCode == 200 ? res.body.toString() : Future.error(res.body);
  }

  Future<dynamic> update(String id, Map<String, Object> fieldsValues) async {
    int userId = int.parse(id);
    Response res = await put(
      '$_url?id=$userId',
      body: jsonEncode(fieldsValues),
      headers: _headers,
    );
    return res.statusCode == 200 ? res : Future.error(res.body);
  }
}