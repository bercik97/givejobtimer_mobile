import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/toastr.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  static void launchURL(BuildContext context, String url) async {
    await canLaunch(url)
        ? await launch(url)
        : ToastService.showErrorToast(getTranslated(context, 'couldNotLaunch'));
  }
}
