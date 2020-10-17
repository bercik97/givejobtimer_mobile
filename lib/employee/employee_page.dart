import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/employee/working_time/working_time_page.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/internationalization/util/language_util.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/logout.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/widget/contact_section.dart';

class EmployeePage extends StatefulWidget {
  final User _user;

  EmployeePage(this._user);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  User _user;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    String _employeeInfo = _user.name + ' ' + _user.surname;
    return WillPopScope(
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: DARK,
          appBar: appBar(context, _user, getTranslated(context, 'profile')),
          drawer: employeeSideBar(context, _user),
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
                      text25WhiteBold(utf8.decode(_employeeInfo != null
                          ? _employeeInfo.runes.toList()
                          : '-')),
                      SizedBox(height: 2.5),
                      text20White(LanguageUtil.convertShortNameToFullName(
                              this.context, _user.nationality) +
                          ' ' +
                          LanguageUtil.findFlagByNationality(
                              _user.nationality)),
                      SizedBox(height: 2.5),
                      text18White(getTranslated(context, 'employee') +
                          ' #' +
                          _user.id.toString()),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Material(
                                  color: BRIGHTER_DARK,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return WorkingTimePage(_user);
                                          },
                                        ),
                                      );
                                    },
                                    child: _buildScrollableContainer(
                                        'images/big-employee-work-icon.png',
                                        'workingTime',
                                        'startFinishWork'),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Material(
                                  color: BRIGHTER_DARK,
                                  child: InkWell(
                                    onTap: () => {
                                      showContactDialog(
                                          context,
                                          _user.managerPhone,
                                          _user.managerViber,
                                          _user.managerWhatsApp),
                                    },
                                    child: _buildScrollableContainer(
                                        'images/big-contact-with-manager-icon.png',
                                        'contact',
                                        'contactWithYourManager'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Widget _buildScrollableContainer(
      String imagePath, String title, String subtitle) {
    return Container(
      height: 160,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Image(height: 100, image: AssetImage(imagePath)),
            text18WhiteBold(getTranslated(context, title)),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: textCenter13White(getTranslated(context, subtitle))),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return Logout.logout(context) ?? false;
  }
}
