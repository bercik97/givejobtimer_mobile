import 'dart:convert';

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
import 'package:givejobtimer_mobile/widget/contact_section.dart';

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
                            showContactDialog(context, _employee.phone,
                                _employee.viber, _employee.whatsApp),
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
                            getTranslated(this.context, 'timeWorkedToday') +
                                ': '),
                        text18GreenBold(_employee.timeWorkedToday),
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
}
