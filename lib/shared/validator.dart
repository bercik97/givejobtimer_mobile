import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';

class ValidatorService {
  static String validateLoginCode(String loginCode, BuildContext context) {
    return loginCode.isEmpty
        ? getTranslated(context, 'loginCodeIsRequired')
        : null;
  }
}
