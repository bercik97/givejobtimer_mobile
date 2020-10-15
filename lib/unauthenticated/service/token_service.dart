import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:http/http.dart';

class TokenService {
  final String _url = '$SERVER_IP/tokens';

  Future<String> findTokenRole(String id) async {
    Response res = await get(_url + '/${int.parse(id)}/token-role');
    return res.statusCode == 200 ? res.body : Future.error(res.body);
  }
}
