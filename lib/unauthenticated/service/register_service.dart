import 'dart:convert';

import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/unauthenticated/dto/create_user_dto.dart';
import 'package:http/http.dart';

class RegisterService {
  final String _url = '$SERVER_IP/users';

  Future<dynamic> registerUser(CreateUserDto dto) async {
    Response res = await post(_url,
        body: jsonEncode(CreateUserDto.jsonEncode(dto)),
        headers: {"content-type": "application/json"});
    return res.statusCode == 200 ? res.body.toString() : Future.error(res.body);
  }
}
