import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/internationalization/util/language_util.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';

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
    return MaterialApp(
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
                        LanguageUtil.findFlagByNationality(_user.nationality)),
                    SizedBox(height: 2.5),
                    text18White(getTranslated(context, 'employee') +
                        ' #' +
                        _user.id.toString()),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
