import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:givejobtimer_mobile/api/employee/dto/employee_dto.dart';
import 'package:givejobtimer_mobile/api/employee/service/employee_service.dart';
import 'package:givejobtimer_mobile/api/group/service/group_service.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/loader_container.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/toastr_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/language_util.dart';
import 'package:givejobtimer_mobile/shared/util/navigator_util.dart';
import 'package:givejobtimer_mobile/shared/widget/hint.dart';

import '../groups_dashboard_page.dart';

class DeleteGroupEmployeesPage extends StatefulWidget {
  final User user;
  final int groupId;

  DeleteGroupEmployeesPage(this.user, this.groupId);

  @override
  _DeleteGroupEmployeesPageState createState() => _DeleteGroupEmployeesPageState();
}

class _DeleteGroupEmployeesPageState extends State<DeleteGroupEmployeesPage> {
  User _user;
  int _groupId;

  EmployeeService _employeeService;
  GroupService _groupService;

  final ScrollController _scrollController = new ScrollController();

  List<EmployeeDto> _employees = new List();
  bool _loading = false;
  bool _isChecked = false;
  bool _isDeleteButtonTapped = false;
  List<bool> _checked = new List();
  LinkedHashSet<int> _selectedIds = new LinkedHashSet();

  @override
  void initState() {
    this._user = widget.user;
    this._groupId = widget.groupId;
    this._employeeService = ServiceInitializer.initialize(context, _user.authHeader, EmployeeService);
    this._groupService = ServiceInitializer.initialize(context, _user.authHeader, GroupService);
    super.initState();
    _loading = true;
    _employeeService.findAllByGroupId(_groupId).then((res) {
      setState(() {
        _employees = res;
        _employees.forEach((e) => _checked.add(false));
        _loading = false;
      });
    }).catchError((onError) {
      _showFailureDialog();
    });
  }

  _showFailureDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          child: AlertDialog(
            backgroundColor: DARK,
            title: textGreen(getTranslated(this.context, 'failure')),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  textWhite(getTranslated(this.context, 'groupNoEmployees')),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: textWhite(getTranslated(this.context, 'goToGroupsDashboard')),
                onPressed: () => _resetAndOpenPage(),
              ),
            ],
          ),
          onWillPop: _navigateToGroupDashboard,
        );
      },
    );
  }

  Future<bool> _navigateToGroupDashboard() async {
    _resetAndOpenPage();
    return true;
  }

  void _resetAndOpenPage() {
    NavigatorUtil.navigateReplacement(context, GroupsDashboardPage(_user));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loader(appBar(context, _user, getTranslated(context, 'loading')), managerSideBar(context, _user));
    }
    return WillPopScope(
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: DARK,
          appBar: appBar(context, _user, getTranslated(context, 'removingEmployeesFromGroup')),
          drawer: managerSideBar(context, _user),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 5),
                _buildSelectUnselectAllCheckbox(),
                _buildEmployees(),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
      onWillPop: () => NavigatorUtil.onWillPopNavigate(context, GroupsDashboardPage(_user)),
    );
  }

  Widget _buildSelectUnselectAllCheckbox() {
    return ListTileTheme(
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
              _selectedIds.addAll(_employees.map((e) => e.employeeId));
            } else
              _selectedIds.clear();
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildEmployees() {
    return Expanded(
      flex: 2,
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _employees.length,
          itemBuilder: (BuildContext context, int index) {
            EmployeeDto employee = _employees[index];
            int foundIndex = 0;
            for (int i = 0; i < _employees.length; i++) {
              if (_employees[i].employeeId == employee.employeeId) {
                foundIndex = i;
              }
            }
            String info = employee.name + ' ' + employee.surname;
            String nationality = employee.nationality;
            return Card(
              color: DARK,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: BRIGHTER_DARK,
                    child: ListTileTheme(
                      contentPadding: EdgeInsets.only(right: 10),
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: text20WhiteBold(utf8.decode(info.runes.toList()) + ' ' + LanguageUtil.findFlagByNationality(nationality)),
                        subtitle: Row(
                          children: [
                            textWhite(getTranslated(this.context, 'loginCode') + ': '),
                            textGreen(employee.loginCode),
                          ],
                        ),
                        activeColor: GREEN,
                        checkColor: WHITE,
                        value: _checked[foundIndex],
                        onChanged: (bool value) {
                          setState(() {
                            _checked[foundIndex] = value;
                            if (value) {
                              _selectedIds.add(_employees[foundIndex].employeeId);
                            } else {
                              _selectedIds.remove(_employees[foundIndex].employeeId);
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
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
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
            onPressed: () => NavigatorUtil.navigateReplacement(context, GroupsDashboardPage(_user)),
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
            color: GREEN,
            onPressed: () => _isDeleteButtonTapped ? null : _handleDeleteBtn(),
          ),
        ],
      ),
    );
  }

  _handleDeleteBtn() {
    setState(() => _isDeleteButtonTapped = true);
    if (_selectedIds.isEmpty) {
      showHint(context, getTranslated(context, 'needToSelectEmployees'), getTranslated(context, 'youWantToRemoveFromGroup'));
      setState(() => _isDeleteButtonTapped = false);
      return;
    }
    showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
    _groupService.deleteGroupEmployees(_groupId, _selectedIds.map((e) => e.toString()).toList()).then((value) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        ToastService.showSuccessToast(getTranslated(context, 'successfullyRemovedGroupEmployees'));
        NavigatorUtil.navigate(this.context, GroupsDashboardPage(_user));
      });
    }).catchError((onError) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        ToastService.showErrorToast(getTranslated(context, 'smthWentWrong'));
        setState(() => _isDeleteButtonTapped = false);
      });
    });
  }
}
