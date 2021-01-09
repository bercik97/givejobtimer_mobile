import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/main.dart';
import 'package:givejobtimer_mobile/shared/service/toastr_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/unauthenticated/login_page.dart';

import '../colors.dart';

class Logout {
  static logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textWhite(getTranslated(context, 'logout')),
          content: textWhite(getTranslated(context, 'logoutConfirm')),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(context, 'yes')),
              onPressed: () => logoutWithoutConfirm(context, getTranslated(context, 'logoutSuccessfully')),
            ),
            FlatButton(child: textWhite(getTranslated(context, 'no')), onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  static logoutWithoutConfirm(BuildContext context, String msg) {
    storage.delete(key: 'authorization');
    storage.delete(key: 'role');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (e) => false);
    if (msg != null) {
      ToastService.showSuccessToast(msg);
    }
  }

  static handle401WithLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textWhite(getTranslated(context, 'accountExpired')),
          content: textWhite(getTranslated(context, 'yourAccountProbablyExpired')),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(context, 'ok')),
              onPressed: () => logoutWithoutConfirm(context, null),
            ),
          ],
        );
      },
    );
  }
}
