import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/internationalization/util/language_util.dart';
import 'package:givejobtimer_mobile/manager/dto/employee_dto.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/url_util.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart';

class ManagerEmployeeProfilePage extends StatefulWidget {
  final User _user;
  final EmployeeDto _employee;

  ManagerEmployeeProfilePage(this._user, this._employee);

  @override
  _ManagerEmployeeProfilePageState createState() =>
      _ManagerEmployeeProfilePageState();
}

class _ManagerEmployeeProfilePageState
    extends State<ManagerEmployeeProfilePage> {
  User _user;
  EmployeeDto _employee;

  String _today = DateTime.now().toString().substring(0, 10);

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    this._employee = widget._employee;
    String _employeeInfo = _employee.name + ' ' + _employee.surname;
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, _user, getTranslated(context, 'profile')),
        drawer: managerSideBar(context, _user),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('images/big-employee-icon.png')),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: text25WhiteBold(utf8.decode(
                              _employeeInfo != null
                                  ? _employeeInfo.runes.toList()
                                  : '-')),
                        ),
                        IconButton(
                          icon: icon50Green(Icons.phone),
                          onPressed: () => {
                            showSlideDialog(
                                context: context,
                                backgroundColor: DARK,
                                child: buildContactSection(
                                    context,
                                    _employee.phone,
                                    _employee.viber,
                                    _employee.whatsApp))
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 2.5),
                    text20White(LanguageUtil.convertShortNameToFullName(
                            this.context, _employee.nationality) +
                        ' ' +
                        LanguageUtil.findFlagByNationality(
                            _employee.nationality)),
                    SizedBox(height: 2.5),
                    text18White(getTranslated(context, 'employee') +
                        ' #' +
                        _employee.id.toString()),
                    SizedBox(height: 20),
                    text22WhiteBold(
                        getTranslated(context, 'statisticsForToday') +
                            ' $_today'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        text18White(
                            getTranslated(this.context, 'hoursWorked') + ': '),
                        text18GreenBold("0"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        text18White(
                            getTranslated(this.context, 'workplace') + ': '),
                        text18GreenBold("Słupsk ul. Lawendowa"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        text18White(
                            getTranslated(this.context, 'status') + ': '),
                        text18GreenBold(
                            getTranslated(this.context, 'finishedWork')),
                        iconGreen(Icons.done)
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
                onPressed: () =>
                    _launchApp(context, 'whatsapp', whatsAppNumber),
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
}
