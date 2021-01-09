import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';

class ValidatorService {
  static String validateLoginCode(String loginCode, BuildContext context) {
    return loginCode.isEmpty ? getTranslated(context, 'loginCodeIsRequired') : null;
  }

  static String validateWorkplace(String workplace, BuildContext context) {
    if (workplace.isEmpty) {
      return getTranslated(context, 'workplaceIsRequired');
    } else if (workplace.length > 200) {
      return getTranslated(context, 'workplaceWrongLength');
    }
    return null;
  }
}
