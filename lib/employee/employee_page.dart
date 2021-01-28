import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/api/employee/service/employee_service.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/user/service/user_service.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/employee/working_time/working_time_page.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/page/edit_user_page.dart';
import 'package:givejobtimer_mobile/shared/service/logout_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/language_util.dart';
import 'package:givejobtimer_mobile/shared/util/navigator_util.dart';
import 'package:givejobtimer_mobile/shared/widget/contact_section.dart';

class EmployeePage extends StatefulWidget {
  final User _user;

  EmployeePage(this._user);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  User _user;
  EmployeeService _employeeService;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    String _employeeInfo = _user.name + ' ' + _user.surname;
    this._employeeService = ServiceInitializer.initialize(context, _user.authHeader, EmployeeService);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage('images/big-employee-icon.png')),
                        ),
                      ),
                      Ink(
                        decoration: ShapeDecoration(color: GREEN, shape: CircleBorder()),
                        child: IconButton(
                          icon: iconDark(Icons.border_color),
                          onPressed: () => NavigatorUtil.navigate(context, EditUserPage(_user)),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      text25WhiteBold(utf8.decode(_employeeInfo != null ? _employeeInfo.runes.toList() : '-')),
                      SizedBox(height: 2.5),
                      text20White(LanguageUtil.convertShortNameToFullName(this.context, _user.nationality) + ' ' + LanguageUtil.findFlagByNationality(_user.nationality)),
                      SizedBox(height: 2.5),
                      text18White(getTranslated(context, 'employee') + ' #' + _user.id.toString()),
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
                                    onTap: () => Navigator.of(context).push(
                                      CupertinoPageRoute<Null>(
                                        builder: (BuildContext context) {
                                          return WorkingTimePage(_user);
                                        },
                                      ),
                                    ),
                                    child: _buildScrollableContainer('images/big-employee-work-icon.png', 'workingTime', 'startFinishWork'),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Material(
                                  color: BRIGHTER_DARK,
                                  child: InkWell(
                                    onTap: () => showContactDialog(context, _employeeService, int.parse(_user.employeeId)),
                                    child: _buildScrollableContainer('images/big-contact-with-manager-icon.png', 'contact', 'contactWithYourCoordinator'),
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

  Widget _buildScrollableContainer(String imagePath, String title, String subtitle) {
    return Container(
      height: 160,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Image(height: 100, image: AssetImage(imagePath)),
            text18WhiteBold(getTranslated(context, title)),
            Padding(padding: EdgeInsets.only(left: 10, right: 10), child: textCenter13White(getTranslated(context, subtitle))),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return Logout.logout(context) ?? false;
  }
}
