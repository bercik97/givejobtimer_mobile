import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

bugReportDialog(BuildContext context) {
  slideDialog.showSlideDialog(
    context: context,
    backgroundColor: DARK,
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          text20GreenBold(getTranslated(context, 'bugReport')),
          SizedBox(height: 10),
          textCenter20White(getTranslated(context, 'somethingWrongWithApplication')),
          textCenter20White(getTranslated(context, 'contactWithUsByGivenEmail')),
          SizedBox(height: 15),
          SelectableText('givejob.software@gmail.com', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 17, color: WHITE)),
        ],
      ),
    ),
  );
}
