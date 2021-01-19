import 'dart:collection';
import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/api/employee/dto/employee_dto.dart';
import 'package:givejobtimer_mobile/api/employee/service/employee_service.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/pages/employees/employee_dates_page.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_employee_profile_page.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/manager/shared/navigate_button.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/loader_container.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/icons_legend_util.dart';
import 'package:givejobtimer_mobile/shared/util/language_util.dart';
import 'package:givejobtimer_mobile/shared/widget/icons_legend_dialog.dart';
import 'package:shimmer/shimmer.dart';

class EmployeesPage extends StatefulWidget {
  final User _user;

  EmployeesPage(this._user);

  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  EmployeeService _employeeService;

  User _user;

  List<EmployeeDto> _employees = new List();
  List<EmployeeDto> _filteredEmployees = new List();
  bool _loading = false;

  bool _isChecked = false;
  List<bool> _checked = new List();
  LinkedHashSet<int> _selectedIds = new LinkedHashSet();

  @override
  void initState() {
    this._user = widget._user;
    this._employeeService = ServiceInitializer.initialize(context, _user.authHeader, EmployeeService);
    super.initState();
    _loading = true;
    _employeeService.findAllByManagerId(_user.managerId).then((res) {
      setState(() {
        _employees = res;
        _employees.forEach((e) => _checked.add(false));
        _filteredEmployees = _employees;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loader(appBar(context, _user, getTranslated(context, 'loading')), managerSideBar(context, _user));
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
              padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: TextFormField(
                autofocus: false,
                autocorrect: true,
                cursorColor: WHITE,
                style: TextStyle(color: WHITE),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: WHITE, width: 2)),
                  counterStyle: TextStyle(color: WHITE),
                  border: OutlineInputBorder(),
                  labelText: getTranslated(context, 'search'),
                  prefixIcon: iconWhite(Icons.search),
                  labelStyle: TextStyle(color: WHITE),
                ),
                onChanged: (string) {
                  setState(
                    () {
                      _filteredEmployees = _employees.where((u) => ((u.name + ' ' + u.surname).toLowerCase().contains(string.toLowerCase()))).toList();
                    },
                  );
                },
              ),
            ),
            ListTileTheme(
              contentPadding: EdgeInsets.only(left: 3),
              child: CheckboxListTile(
                title: textWhite(getTranslated(this.context, 'selectUnselectAll')),
                value: _isChecked,
                activeColor: GREEN,
                checkColor: WHITE,
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                    List<bool> l = new List();
                    _checked.forEach((b) => l.add(value));
                    _checked = l;
                    if (value) {
                      _selectedIds.addAll(_filteredEmployees.map((e) => e.employeeId));
                    } else
                      _selectedIds.clear();
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
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
                                                  duration: Duration(milliseconds: 100),
                                                  scaleFactor: 2,
                                                  onPressed: () => {
                                                    Navigator.push(
                                                      this.context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ManagerEmployeeProfilePage(
                                                          _user,
                                                          employee,
                                                          _handleWorkStatus(MainAxisAlignment.center, employee.workStatus, employee.workplace, employee.workplaceCode),
                                                        ),
                                                      ),
                                                    ),
                                                  },
                                                  child: Image(
                                                    image: AssetImage('images/big-employee-icon.png'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: text20WhiteBold(utf8.decode(info.runes.toList()) + ' ' + LanguageUtil.findFlagByNationality(nationality)),
                                          subtitle: Column(
                                            children: <Widget>[
                                              Align(
                                                  child: Row(
                                                    children: <Widget>[
                                                      textWhite(getTranslated(this.context, 'timeWorkedToday') + ': '),
                                                      textGreenBold(employee.timeWorkedToday != null ? employee.timeWorkedToday : getTranslated(this.context, 'empty')),
                                                    ],
                                                  ),
                                                  alignment: Alignment.topLeft),
                                              _handleWorkStatus(MainAxisAlignment.start, employee.workStatus, employee.workplace, employee.workplaceCode),
                                            ],
                                          ),
                                          onTap: () => {
                                            Navigator.push(
                                              this.context,
                                              MaterialPageRoute(
                                                builder: (context) => EmployeeDatesPage(_user, employee),
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
        bottomNavigationBar: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              SizedBox(width: 1),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: Image(image: AssetImage('images/dark-hours-icon.png')),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: Image(image: AssetImage('images/dark-play-icon.png')),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: Image(image: AssetImage('images/dark-stop-icon.png')),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 1),
            ],
          ),
        ),
        floatingActionButton: iconsLegendDialog(
          context,
          getTranslated(context, 'iconsLegend'),
          [
            IconsLegendUtil.buildImageRow('images/big-employee-icon.png', getTranslated(context, 'employeeProfile')),
            IconsLegendUtil.buildImageRow('images/hours-icon.png', getTranslated(context, 'settingHours')),
            IconsLegendUtil.buildImageRow('images/play-icon.png', getTranslated(context, 'startingWork')),
            IconsLegendUtil.buildImageRow('images/stop-icon.png', getTranslated(context, 'stoppingWork')),
          ],
        ),
      ),
    );
  }

  Widget _handleWorkStatus(MainAxisAlignment alignment, String workStatus, String workplace, String workplaceCode) {
    switch (workStatus) {
      case 'Done':
        return _buildWorkStatusRow(
          alignment,
          iconGreen(Icons.check),
          textGreen(getTranslated(context, 'workIsDoneStatus')),
          textGreen(workplace != null ? workplace : '-'),
          textGreen(workplaceCode != null ? workplaceCode : '-'),
        );
      case 'In progress':
        return _buildWorkStatusRow(
          alignment,
          iconOrange(Icons.timer),
          textOrange(getTranslated(context, 'workIsInProgress')),
          textOrange(workplace != null ? workplace : '-'),
          textOrange(workplaceCode != null ? workplaceCode : '-'),
        );
      default:
        return _buildWorkStatusRow(
          alignment,
          iconRed(Icons.remove),
          textRed(getTranslated(context, 'workDoNotStarted')),
          textRed('-'),
          textRed('-'),
        );
    }
  }

  Widget _buildWorkStatusRow(MainAxisAlignment alignment, Icon icon, Widget workStatusWidget, Widget workplaceWidget, Widget workplaceCodeWidget) {
    return Align(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: alignment,
            children: <Widget>[textWhite(getTranslated(context, 'status') + ': '), icon, workStatusWidget],
          ),
          Row(
            mainAxisAlignment: alignment,
            children: <Widget>[textWhite(getTranslated(context, 'workplace') + ': '), workplaceWidget],
          ),
          Row(
            mainAxisAlignment: alignment,
            children: <Widget>[textWhite(getTranslated(context, 'workplaceId') + ': '), workplaceCodeWidget],
          ),
        ],
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
            child: textCenter19White(getTranslated(context, 'youHaveNoEmployees')),
          ),
        ),
      ],
    );
  }

  Future<Null> _refresh() {
    return _employeeService.findAllByManagerId(_user.managerId).then((res) {
      setState(() {
        _employees = res;
        _filteredEmployees = _employees;
        _loading = false;
      });
    });
  }
}
