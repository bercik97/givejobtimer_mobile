import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/api/employee/service/employee_service.dart';
import 'package:givejobtimer_mobile/api/shared/dto/contact_dto.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/url_util.dart';

import 'circular_progress_indicator.dart';

void showContactDialog(BuildContext context, EmployeeService employeeService, num employeeId) {
  showGeneralDialog(
    context: context,
    barrierColor: DARK.withOpacity(0.95),
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return FutureBuilder(
        future: employeeService.findContactsForManagerById(employeeId),
        builder: (BuildContext context, AsyncSnapshot<List<ContactDto>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(child: circularProgressIndicator()),
            );
          } else {
            List<ContactDto> contacts = snapshot.data;
            return SizedBox.expand(
              child: Scaffold(
                backgroundColor: Colors.black12,
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              buildContactSection(context, contacts),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      textWhite(getTranslated(context, 'close')),
                      iconWhite(Icons.close),
                    ],
                  ),
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            );
          }
        },
      );
    },
  );
}

Widget buildContactSection(BuildContext context, List<ContactDto> contacts) {
  return Column(
    children: [
      SizedBox(height: 40),
      for (var contact in contacts) _buildContact(context, contact),
    ],
  );
}

Widget _buildContact(BuildContext context, ContactDto contact) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        textCenter20GreenBold(getTranslated(context, 'coordinator') + ' → ' + utf8.decode(contact.userInfo.runes.toList())),
        contact.phone != null && contact.phone != '' ? _buildPhoneNumber(context, contact.phone) : _buildEmptyListTile(context, 'phone'),
        contact.viber != null && contact.viber != '' ? _buildViber(context, contact.viber) : _buildEmptyListTile(context, 'viber'),
        contact.whatsApp != null && contact.whatsApp != '' ? _buildWhatsApp(context, contact.whatsApp) : _buildEmptyListTile(context, 'whatsApp'),
      ],
    ),
  );
}

Widget _buildPhoneNumber(BuildContext context, String phoneNumber) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      textCenter16GreenBold(getTranslated(context, 'phone') + ' → '),
      SelectableText(phoneNumber, style: TextStyle(fontSize: 15, color: WHITE)),
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
  );
}

Widget _buildViber(BuildContext context, String viberNumber) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      textCenter16GreenBold(getTranslated(context, 'viber') + ' → '),
      SelectableText(viberNumber, style: TextStyle(fontSize: 15, color: WHITE)),
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
  );
}

Widget _buildWhatsApp(BuildContext context, String whatsAppNumber) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      textCenter16GreenBold(getTranslated(context, 'whatsApp') + ' → '),
      SelectableText(whatsAppNumber, style: TextStyle(fontSize: 15, color: WHITE)),
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
