import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/internationalization/util/language_util.dart';
import 'package:givejobtimer_mobile/manager/dto/employee_dto.dart';
import 'package:givejobtimer_mobile/manager/pages/employees/employee_dates_page.dart';
import 'package:givejobtimer_mobile/manager/service/manager_service.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_employee_profile_page.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/manager/shared/navigate_button.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:shimmer/shimmer.dart';

class EmployeesPage extends StatefulWidget {
  final User _user;

  EmployeesPage(this._user);

  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  ManagerService _managerService;

  User _user;

  List<EmployeeDto> _employees = new List();
  List<EmployeeDto> _filteredEmployees = new List();
  bool _loading = false;

  @override
  void initState() {
    this._user = widget._user;
    this._managerService = new ManagerService(_user.authHeader);
    super.initState();
    _loading = true;
    _managerService.findAllEmployees(_user.managerId).then((res) {
      setState(() {
        _employees = res;
        _filteredEmployees = _employees;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container();
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, _user, getTranslated(context, 'employees')),
        drawer: managerSideBar(context, _user),
        body: Column(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: TextFormField(
                autofocus: false,
                autocorrect: true,
                cursorColor: WHITE,
                style: TextStyle(color: WHITE),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: WHITE, width: 2)),
                    counterStyle: TextStyle(color: WHITE),
                    border: OutlineInputBorder(),
                    labelText: getTranslated(context, 'search'),
                    prefixIcon: iconWhite(Icons.search),
                    labelStyle: TextStyle(color: WHITE)),
                onChanged: (string) {
                  setState(
                    () {
                      _filteredEmployees = _employees
                          .where((u) => ((u.name + ' ' + u.surname)
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                          .toList();
                    },
                  );
                },
              ),
            ),
            _employees.isNotEmpty
                ? Expanded(
                    child: RefreshIndicator(
                      color: DARK,
                      backgroundColor: WHITE,
                      onRefresh: _refresh,
                      child: ListView.builder(
                        itemCount: _filteredEmployees.length,
                        itemBuilder: (BuildContext context, int index) {
                          EmployeeDto employee = _filteredEmployees[index];
                          String info = employee.name + ' ' + employee.surname;
                          String nationality = employee.nationality;
                          return Card(
                            color: DARK,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                  color: BRIGHTER_DARK,
                                  child: InkWell(
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: Tab(
                                            icon: Container(
                                              child: Shimmer.fromColors(
                                                baseColor: GREEN,
                                                highlightColor: WHITE,
                                                child: BouncingWidget(
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  scaleFactor: 2,
                                                  onPressed: () => {
                                                    Navigator.push(
                                                      this.context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ManagerEmployeeProfilePage(
                                                                _user,
                                                                employee),
                                                      ),
                                                    ),
                                                  },
                                                  child: Image(
                                                    image: AssetImage(
                                                        'images/big-employee-icon.png'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: text20WhiteBold(
                                              utf8.decode(info.runes.toList()) +
                                                  ' ' +
                                                  LanguageUtil
                                                      .findFlagByNationality(
                                                          nationality)),
                                          subtitle: Column(
                                            children: <Widget>[
                                              Align(
                                                  child: Row(
                                                    children: <Widget>[
                                                      textWhite(getTranslated(
                                                              this.context,
                                                              'timeWorkedToday') +
                                                          ': '),
                                                      textGreenBold(employee
                                                                  .timeWorkedToday !=
                                                              null
                                                          ? employee
                                                              .timeWorkedToday
                                                          : getTranslated(
                                                              this.context,
                                                              'empty')),
                                                    ],
                                                  ),
                                                  alignment: Alignment.topLeft),
                                            ],
                                          ),
                                          onTap: () => {
                                            Navigator.push(
                                              this.context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EmployeeDatesPage(
                                                        _user, employee),
                                              ),
                                            ),
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : _handleEmptyData()
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: navigateButton(context, _user),
      ),
    );
  }

  Widget _handleEmptyData() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child: text20GreenBold(getTranslated(context, 'noEmployees')),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child:
                textCenter19White(getTranslated(context, 'youHaveNoEmployees')),
          ),
        ),
      ],
    );
  }

  Future<Null> _refresh() {
    return _managerService.findAllEmployees(_user.managerId).then((res) {
      setState(() {
        _employees = res;
        _filteredEmployees = _employees;
        _loading = false;
      });
    });
  }
}
