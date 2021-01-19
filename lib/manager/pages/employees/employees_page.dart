import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:givejobtimer_mobile/api/employee/dto/employee_dto.dart';
import 'package:givejobtimer_mobile/api/employee/service/employee_service.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/work_time/service/work_time_service.dart';
import 'package:givejobtimer_mobile/api/workplace/dto/workplace_dto.dart';
import 'package:givejobtimer_mobile/api/workplace/service/workplace_service.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/pages/employees/employee_dates_page.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/loader_container.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/dialog_service.dart';
import 'package:givejobtimer_mobile/shared/service/toastr_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/icons_legend_util.dart';
import 'package:givejobtimer_mobile/shared/util/language_util.dart';
import 'package:givejobtimer_mobile/shared/widget/hint.dart';
import 'package:givejobtimer_mobile/shared/widget/icons_legend_dialog.dart';

class EmployeesPage extends StatefulWidget {
  final User _user;

  EmployeesPage(this._user);

  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  EmployeeService _employeeService;
  WorkplaceService _workplaceService;
  WorkTimeService _workTimeService;

  User _user;

  List<EmployeeDto> _employees = new List();
  List<EmployeeDto> _filteredEmployees = new List();

  List<WorkplaceDto> _workplaces = new List();
  List<int> _workplacesRadioValues = new List();
  int _chosenIndex = -1;
  bool _isChoseWorkplaceBtnDisabled = true;
  bool _isChoseWorkplaceButtonTapped = false;
  bool _isPauseButtonTapped = false;

  bool _loading = false;

  bool _isChecked = false;
  List<bool> _checked = new List();
  LinkedHashSet<int> _selectedIds = new LinkedHashSet();
  LinkedHashSet<EmployeeDto> _selectedEmployees = new LinkedHashSet();

  @override
  void initState() {
    this._user = widget._user;
    this._employeeService = ServiceInitializer.initialize(context, _user.authHeader, EmployeeService);
    this._workplaceService = ServiceInitializer.initialize(context, _user.authHeader, WorkplaceService);
    this._workTimeService = ServiceInitializer.initialize(context, _user.authHeader, WorkTimeService);
    super.initState();
    _loading = true;
    _employeeService.findAllByManagerId(_user.managerId).then((res) {
      setState(() {
        _employees = res;
        _employees.forEach((e) => _checked.add(false));
        _filteredEmployees = _employees;
        _workplaceService.findAllByManagerId(_user.managerId).then((res) {
          setState(() {
            _workplaces = res;
            _workplaces.forEach((element) => _workplacesRadioValues.add(-1));
            _loading = false;
          });
        });
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
                      _selectedEmployees.addAll(_filteredEmployees);
                    } else
                      _selectedIds.clear();
                    _selectedEmployees.clear();
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
                          int foundIndex = 0;
                          for (int i = 0; i < _employees.length; i++) {
                            if (_employees[i].employeeId == employee.employeeId) {
                              foundIndex = i;
                            }
                          }
                          return Card(
                            color: DARK,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Ink(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  height: 123,
                                  color: BRIGHTER_DARK,
                                  child: ListTileTheme(
                                    contentPadding: EdgeInsets.only(right: 10),
                                    child: CheckboxListTile(
                                      controlAffinity: ListTileControlAffinity.leading,
                                      activeColor: GREEN,
                                      checkColor: WHITE,
                                      value: _checked[foundIndex],
                                      onChanged: (bool value) {
                                        setState(() {
                                          _checked[foundIndex] = value;
                                          if (value) {
                                            _selectedIds.add(_employees[foundIndex].employeeId);
                                            _selectedEmployees.add(_employees[foundIndex]);
                                          } else {
                                            _selectedIds.remove(_employees[foundIndex].employeeId);
                                            _selectedEmployees.remove(_employees[foundIndex]);
                                          }
                                          int selectedIdsLength = _selectedIds.length;
                                          if (selectedIdsLength == _employees.length) {
                                            _isChecked = true;
                                          } else if (selectedIdsLength == 0) {
                                            _isChecked = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => {
                                      Navigator.push(
                                        this.context,
                                        MaterialPageRoute(
                                          builder: (context) => EmployeeDatesPage(_user, employee),
                                        ),
                                      ),
                                    },
                                    child: Ink(
                                      color: BRIGHTER_DARK,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            text20WhiteBold(utf8.decode(info.runes.toList()) + ' ' + LanguageUtil.findFlagByNationality(nationality)),
                                            Row(
                                              children: <Widget>[
                                                textWhite(getTranslated(this.context, 'loginCode') + ': '),
                                                textGreenBold(employee.loginCode),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                textWhite(getTranslated(this.context, 'timeWorkedToday') + ': '),
                                                textGreenBold(employee.timeWorkedToday != null ? employee.timeWorkedToday : getTranslated(this.context, 'empty')),
                                              ],
                                            ),
                                            _handleWorkStatus(MainAxisAlignment.start, employee.workStatus, employee.workplace, employee.workplaceCode)
                                          ],
                                        ),
                                      ),
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
                  onPressed: () {
                    if (_selectedIds.isEmpty) {
                      showHint(context, getTranslated(context, 'needToSelectRecords') + ' ', getTranslated(context, 'whichYouWantToUpdate'));
                      return;
                    }
                    if (_areSelectedEmployeesInWork()) {
                      showHint(context, getTranslated(context, 'someOfSelectedEmployeesAreInWork') + ' ', getTranslated(context, 'ifYouWantToStartWorkPleaseFirstStopTheirWork'));
                      return;
                    }
                  },
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: Image(image: AssetImage('images/dark-play-icon.png')),
                  onPressed: () {
                    if (_selectedIds.isEmpty) {
                      showHint(context, getTranslated(context, 'needToSelectRecords') + ' ', getTranslated(context, 'whichYouWantToUpdate'));
                      return;
                    }
                    if (_areSelectedEmployeesInWork()) {
                      showHint(context, getTranslated(context, 'someOfSelectedEmployeesAreInWork') + ' ', getTranslated(context, 'ifYouWantToStartWorkPleaseFirstStopTheirWork'));
                      return;
                    }
                    if (_workplaces.isEmpty) {
                      showHint(context, getTranslated(context, 'noWorkplaces') + ' ', getTranslated(context, 'goToWorkplacesSectionAndAddSomeWorkplaces'));
                      return;
                    }
                    _startSelectedEmployeesWork();
                  },
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: Image(image: AssetImage('images/dark-stop-icon.png')),
                  onPressed: () {
                    if (_selectedIds.isEmpty) {
                      showHint(context, getTranslated(context, 'needToSelectRecords') + ' ', getTranslated(context, 'whichYouWantToUpdate'));
                      return;
                    }
                    if (_areSelectedEmployeesNotInWork()) {
                      showHint(context, getTranslated(context, 'someOfSelectedEmployeesAreNotInWork') + ' ', getTranslated(context, 'ifYouWantToStopWorkPleaseFirstStartTheirWork'));
                      return;
                    }
                    _showPauseWorkDialog();
                  },
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

  bool _areSelectedEmployeesInWork() {
    for (var employee in _selectedEmployees) {
      if (employee.workStatus == 'In progress') {
        return true;
      }
    }
    return false;
  }

  bool _areSelectedEmployeesNotInWork() {
    for (var employee in _selectedEmployees) {
      if (employee.workStatus != 'In progress') {
        return true;
      }
    }
    return false;
  }

  void _startSelectedEmployeesWork() {
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              backgroundColor: Colors.black12,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Column(
                          children: [
                            textCenter20GreenBold(getTranslated(this.context, 'chooseWorkplaceWhereSelectedEmployeesWillStartWork')),
                          ],
                        ),
                      ),
                      SizedBox(height: 7.5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < _workplaces.length; i++)
                            _buildRadioBtn(
                              color: GREEN,
                              title: utf8.decode(_workplaces[i].name.runes.toList()),
                              value: 0,
                              groupValue: _workplacesRadioValues[i],
                              onChanged: (newValue) => setState(
                                () {
                                  if (_chosenIndex != -1) {
                                    _workplacesRadioValues[_chosenIndex] = -1;
                                  }
                                  _workplacesRadioValues[i] = newValue;
                                  _chosenIndex = i;
                                  _isChoseWorkplaceBtnDisabled = false;
                                },
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            elevation: 0,
                            height: 50,
                            minWidth: 40,
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[iconWhite(Icons.close)],
                            ),
                            color: Colors.red,
                            onPressed: () {
                              if (_chosenIndex != -1) {
                                _workplacesRadioValues[_chosenIndex] = -1;
                              }
                              _chosenIndex = -1;
                              _isChoseWorkplaceBtnDisabled = true;
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 25),
                          MaterialButton(
                            elevation: 0,
                            height: 50,
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[iconWhite(Icons.check)],
                            ),
                            color: !_isChoseWorkplaceBtnDisabled ? GREEN : Colors.grey,
                            onPressed: () => _isChoseWorkplaceBtnDisabled || _isChoseWorkplaceButtonTapped ? null : _handleChoseWorkplaceBtn(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void _handleChoseWorkplaceBtn() {
    showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
    _workTimeService.createForEmployees(_selectedIds.map((el) => el.toString()).toList(), _workplaces[_chosenIndex].id).then((value) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        _uncheckAll();
        _refresh();
        Navigator.pop(context);
        ToastService.showSuccessToast(getTranslated(context, 'workHasBeenStartedSuccessfullyForSelectedEmployees'));
        setState(() => _isChoseWorkplaceButtonTapped = false);
      });
    }).catchError((onError) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        DialogService.showCustomDialog(
          context: context,
          titleWidget: textRed(getTranslated(context, 'error')),
          content: getTranslated(context, 'smthWentWrong'),
        );
        setState(() => _isChoseWorkplaceButtonTapped = false);
      });
    });
  }

  _showPauseWorkDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textGreen(getTranslated(context, 'confirmation')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[textCenter20Green(getTranslated(context, 'pauseWorkForSelectedEmployeesConfirmation'))],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                FlatButton(
                  child: textWhite(getTranslated(context, 'workIsDone')),
                  onPressed: () => _isPauseButtonTapped ? null : _pauseSelectedEmployeesWork(),
                ),
                FlatButton(child: textWhite(getTranslated(context, 'no')), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ],
        );
      },
    );
  }

  _pauseSelectedEmployeesWork() {
    setState(() => _isPauseButtonTapped = true);
    showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
    _workTimeService.finishForEmployees(_selectedIds.map((el) => el.toString()).toList()).then((res) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        _uncheckAll();
        _refresh();
        Navigator.pop(context);
        ToastService.showSuccessToast(getTranslated(context, 'workHasBeenStoppedSuccessfullyForSelectedEmployees'));
        setState(() => _isPauseButtonTapped = false);
      });
    }).catchError((onError) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        DialogService.showCustomDialog(
          context: context,
          titleWidget: textRed(getTranslated(context, 'error')),
          content: getTranslated(context, 'smthWentWrong'),
        );
        setState(() => _isPauseButtonTapped = false);
      });
    });
  }

  Widget _buildRadioBtn({Color color, String title, int value, int groupValue, Function onChanged}) {
    return RadioListTile(
      activeColor: color,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: textWhite(title),
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
        _workplaceService.findAllByManagerId(_user.managerId).then((res) {
          setState(() {
            _workplaces = res;
            _workplaces.forEach((element) => _workplacesRadioValues.add(-1));
            _loading = false;
          });
        });
      });
    });
  }

  void _uncheckAll() {
    _selectedIds.clear();
    _selectedEmployees.clear();
    _isChecked = false;
    List<bool> l = new List();
    _checked.forEach((b) => l.add(false));
    _checked = l;
  }
}
