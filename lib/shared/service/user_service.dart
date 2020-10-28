import 'dart:convert';
import 'dart:io';

import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/dto/update_user_dto.dart';
import 'package:http/http.dart';

class UserService {
  final String authHeader;

  UserService(this.authHeader);

  static const String _url = '$SERVER_IP/users';

  Future<dynamic> update(String userId, UpdateUserDto dto) async {
    Response res = await put('$_url?id=$userId',
        body: jsonEncode(UpdateUserDto.jsonEncode(dto)),
        headers: {
          HttpHeaders.authorizationHeader: authHeader,
          'content-type': 'application/json'
        });
    return res.statusCode == 200 ? res : Future.error(res.body);
  }
}
