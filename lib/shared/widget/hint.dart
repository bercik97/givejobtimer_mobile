import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import '../colors.dart';
import '../texts.dart';

void showHint(BuildContext context, String stText, String ndText) {
  slideDialog.showSlideDialog(
    context: context,
    backgroundColor: DARK,
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          text20GreenBold(getTranslated(context, 'hint')),
          SizedBox(height: 10),
          textCenter20White(stText),
          textCenter20White(ndText),
        ],
      ),
    ),
  );
}
