import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/url_util.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

void showContactDialog(
    BuildContext context, String phone, String viber, String whatsApp) {
  slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: buildContactSection(context, phone, viber, whatsApp));
}

Widget buildContactSection(
    BuildContext context, String phone, String viber, String whatsApp) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        phone != null
            ? _buildPhoneNumber(context, phone)
            : _buildEmptyListTile(context, 'phone'),
        viber != null
            ? _buildViber(context, viber)
            : _buildEmptyListTile(context, 'viber'),
        whatsApp != null
            ? _buildWhatsApp(context, whatsApp)
            : _buildEmptyListTile(context, 'whatsApp'),
      ],
    ),
  );
}

Widget _buildPhoneNumber(BuildContext context, String phoneNumber) {
  return ListTile(
    title: textCenter16GreenBold(getTranslated(context, 'phone')),
    subtitle: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SelectableText(phoneNumber,
            style: TextStyle(fontSize: 16, color: WHITE)),
        SizedBox(width: 5),
        IconButton(
          icon: icon30White(Icons.phone),
          onPressed: () => _launchAction(context, 'tel', phoneNumber),
        ),
        IconButton(
          icon: icon30White(Icons.local_post_office),
          onPressed: () => _launchAction(context, 'sms', phoneNumber),
        ),
      ],
    ),
  );
}

Widget _buildViber(BuildContext context, String viberNumber) {
  return ListTile(
    title: textCenter16GreenBold(getTranslated(context, 'viber')),
    subtitle: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SelectableText(viberNumber,
            style: TextStyle(fontSize: 16, color: WHITE)),
        SizedBox(width: 5),
        SizedBox(width: 7.5),
        Padding(
          padding: EdgeInsets.all(4),
          child: Transform.scale(
            scale: 1.2,
            child: BouncingWidget(
              duration: Duration(milliseconds: 100),
              scaleFactor: 2,
              onPressed: () => _launchApp(context, 'viber', viberNumber),
              child: Image(
                width: 40,
                height: 40,
                image: AssetImage('images/viber-logo.png'),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildWhatsApp(BuildContext context, String whatsAppNumber) {
  return ListTile(
    title: textCenter16GreenBold(getTranslated(context, 'whatsApp')),
    subtitle: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SelectableText(whatsAppNumber,
            style: TextStyle(fontSize: 16, color: WHITE)),
        SizedBox(width: 7.5),
        Padding(
          padding: EdgeInsets.all(4),
          child: Transform.scale(
            scale: 1.2,
            child: BouncingWidget(
              duration: Duration(milliseconds: 100),
              scaleFactor: 2,
              onPressed: () => _launchApp(context, 'whatsapp', whatsAppNumber),
              child: Image(
                width: 40,
                height: 40,
                image: AssetImage('images/whatsapp-logo.png'),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

_launchAction(BuildContext context, String action, String number) async {
  String url = action + ':' + number;
  UrlUtil.launchURL(context, url);
}

_launchApp(BuildContext context, String app, String number) async {
  var url = '$app://send?phone=$number';
  UrlUtil.launchURL(context, url);
}

Widget _buildEmptyListTile(BuildContext context, String title) {
  return ListTile(
    title: textCenter16GreenBold(getTranslated(context, title)),
    subtitle: textCenter16White(getTranslated(context, 'empty')),
  );
}
