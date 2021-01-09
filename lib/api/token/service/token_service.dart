import 'dart:convert';

import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:http/http.dart';

class TokenService {
  static const String _url = '$SERVER_IP/tokens';

  Future<Map<String, Object>> findFieldsValuesById(String id, List<String> fields) async {
    int tokenId = int.parse(id);
    Response res = await get('$_url?id=$tokenId&fields=$fields');
    var body = res.body;
    if (res.statusCode == 200) {
      return json.decode(body);
    } else {
      return Future.error(res.body);
    }
  }
}
