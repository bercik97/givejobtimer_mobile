import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/api/user/dto/create_user_dto.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/service/logout_service.dart';
import 'package:http/http.dart';

class UserService {
  final BuildContext _context;
  final Map<String, String> _headers;

  UserService(this._context, this._headers);

  static const String _url = '$SERVER_IP/users';

  Future<dynamic> create(CreateUserDto dto) async {
    Response res = await post(_url, body: jsonEncode(CreateUserDto.jsonEncode(dto)), headers: {"content-type": "application/json"});
    if (res.statusCode == 200) {
      return res.body.toString();
    } else if (res.statusCode == 401) {
      return Logout.handle401WithLogout(_context);
    } else {
      return Future.error(res.body);
    }
  }

  Future<dynamic> update(String id, Map<String, Object> fieldsValues) async {
    int userId = int.parse(id);
    Response res = await put('$_url?id=$userId', body: jsonEncode(fieldsValues), headers: _headers);
    if (res.statusCode == 200) {
      return res;
    } else if (res.statusCode == 401) {
      return Logout.handle401WithLogout(_context);
    } else {
      return Future.error(res.body);
    }
  }
}
