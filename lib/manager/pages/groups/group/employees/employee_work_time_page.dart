import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/work_time/dto/work_time_dates_dto.dart';
import 'package:givejobtimer_mobile/api/work_time/dto/work_time_employee_date_dto.dart';
import 'package:givejobtimer_mobile/api/work_time/service/work_time_service.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/dialog_service.dart';
import 'package:givejobtimer_mobile/shared/service/toastr_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/widget/circular_progress_indicator.dart';
import 'package:givejobtimer_mobile/shared/widget/hint.dart';

class EmployeeWorkTimePage extends StatefulWidget {
  final User _user;
  final int _employeeId;
  final String _employeeInfo;
  final WorkTimeDatesDto _dto;

  EmployeeWorkTimePage(this._user, this._employeeId, this._employeeInfo, this._dto);

  @override
  _EmployeeWorkTimePageState createState() => _EmployeeWorkTimePageState();
}

class _EmployeeWorkTimePageState extends State<EmployeeWorkTimePage> {
  User _user;
  int _employeeId;
  String _employeeInfo;
  WorkTimeDatesDto _employeeDates;
  WorkTimeService _workTimeService;

  String _date;

  List<WorkTimeDateEmployeeDto> _workTimes = new List();
  Set<int> selectedIds = new Set();

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    this._employeeId = widget._employeeId;
    this._employeeInfo = widget._employeeInfo;
    this._employeeDates = widget._dto;
    this._workTimeService = ServiceInitializer.initialize(context, _user.authHeader, WorkTimeService);
    _date = _employeeDates.year + ' ' + _employeeDates.month;
    if (_workTimes.isEmpty) {
      return MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: DARK,
          appBar: appBar(this.context, _user, _employeeInfo),
          drawer: managerSideBar(this.context, _user),
          body: SingleChildScrollView(
            child: FutureBuilder(
              future: _workTimeService.findAllByEmployeeIdAndDateIn(_employeeId, _date),
              builder: (BuildContext context, AsyncSnapshot<List<WorkTimeDateEmployeeDto>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                  return Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(child: circularProgressIndicator()),
                  );
                } else {
                  _workTimes = snapshot.data;
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Column(
                          children: [
                            ListTile(
                              title: text20White(getTranslated(this.context, 'date')),
                              subtitle: text20GreenBold(_employeeDates.year + ' ' + getTranslated(this.context, _employeeDates.month)),
                            ),
                            ListTile(
                              title: text20White(getTranslated(this.context, 'totalTimeWorked')),
                              subtitle: text20GreenBold(_employeeDates.totalDateTime),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Theme(
                            data: Theme.of(this.context).copyWith(dividerColor: MORE_BRIGHTER_DARK),
                            child: DataTable(
                              columnSpacing: 10,
                              columns: [
                                DataColumn(label: textWhiteBold(getTranslated(this.context, 'date'))),
                                DataColumn(label: textWhiteBold(getTranslated(this.context, 'from'))),
                                DataColumn(label: textWhiteBold(getTranslated(this.context, 'to'))),
                                DataColumn(label: textWhiteBold(getTranslated(this.context, 'sum'))),
                                DataColumn(label: textWhiteBold(getTranslated(this.context, 'workplaceId'))),
                              ],
                              rows: [
                                for (var workTime in _workTimes)
                                  DataRow(
                                    selected: selectedIds.contains(workTime.id),
                                    onSelectChanged: (bool selected) {
                                      onSelectedRow(selected, workTime.id);
                                    },
                                    cells: [
                                      DataCell(textWhite(workTime.date)),
                                      DataCell(textWhite(workTime.startTime)),
                                      DataCell(textWhite(workTime.endTime != null ? workTime.endTime : '-')),
                                      DataCell(textWhite(workTime.totalTime != null ? workTime.totalTime : '-')),
                                      DataCell(textWhite(workTime.workplaceId != null ? workTime.workplaceId : '-')),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            heroTag: "deleteBtn",
            tooltip: getTranslated(context, 'deleteSelectedWorkTimes'),
            backgroundColor: Colors.red,
            onPressed: () => _deleteByIdIn(selectedIds),
            child: Icon(Icons.delete),
          ),
        ),
      );
    } else {
      return MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: DARK,
          appBar: appBar(this.context, _user, _employeeInfo),
          drawer: employeeSideBar(this.context, _user),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Column(
                  children: [
                    ListTile(
                      title: text20White(getTranslated(this.context, 'date')),
                      subtitle: text20GreenBold(_employeeDates.year + ' ' + getTranslated(this.context, _employeeDates.month)),
                    ),
                    ListTile(
                      title: text20White(getTranslated(this.context, 'totalTimeWorked')),
                      subtitle: text20GreenBold(_employeeDates.totalDateTime),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Theme(
                    data: Theme.of(this.context).copyWith(dividerColor: MORE_BRIGHTER_DARK),
                    child: DataTable(
                      columnSpacing: 10,
                      columns: [
                        DataColumn(label: textWhiteBold(getTranslated(this.context, 'date'))),
                        DataColumn(label: textWhiteBold(getTranslated(this.context, 'from'))),
                        DataColumn(label: textWhiteBold(getTranslated(this.context, 'to'))),
                        DataColumn(label: textWhiteBold(getTranslated(this.context, 'sum'))),
                        DataColumn(label: textWhiteBold(getTranslated(this.context, 'workplaceId'))),
                      ],
                      rows: [
                        for (var workTime in _workTimes)
                          DataRow(
                            selected: selectedIds.contains(workTime.id),
                            onSelectChanged: (bool selected) {
                              onSelectedRow(selected, workTime.id);
                            },
                            cells: [
                              DataCell(textWhite(workTime.date)),
                              DataCell(textWhite(workTime.startTime)),
                              DataCell(textWhite(workTime.endTime != null ? workTime.endTime : '-')),
                              DataCell(textWhite(workTime.totalTime != null ? workTime.totalTime : '-')),
                              DataCell(textWhite(workTime.workplaceId != null ? workTime.workplaceId : '-')),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            heroTag: "deleteBtn",
            tooltip: getTranslated(context, 'deleteSelectedWorkTimes'),
            backgroundColor: Colors.red,
            onPressed: () => _deleteByIdIn(selectedIds),
            child: Icon(Icons.delete),
          ),
        ),
      );
    }
  }

  void onSelectedRow(bool selected, int id) {
    setState(() {
      selected ? selectedIds.add(id) : selectedIds.remove(id);
    });
  }

  _deleteByIdIn(Set<int> ids) {
    if (ids.isEmpty) {
      showHint(context, getTranslated(context, 'needToSelectWorkTimes') + ' ', getTranslated(context, 'whichYouWantToRemove'));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textWhite(getTranslated(this.context, 'confirmation')),
          content: textWhite(getTranslated(this.context, 'areYouSureYouWantToDeleteSelectedWorkTimes')),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(this.context, 'yesDeleteThem')),
              onPressed: () {
                showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
                _workTimeService.deleteByIdIn(ids.toList()).then((res) {
                  Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                    Navigator.pop(this.context);
                    _refresh();
                    ToastService.showSuccessToast(getTranslated(this.context, 'selectedWorkTimesRemoved'));
                  });
                }).catchError((onError) {
                  Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                    DialogService.showCustomDialog(
                      context: context,
                      titleWidget: textRed(getTranslated(context, 'error')),
                      content: getTranslated(context, 'smthWentWrong'),
                    );
                  });
                });
              },
            ),
            FlatButton(child: textWhite(getTranslated(this.context, 'no')), onPressed: () => Navigator.of(this.context).pop()),
          ],
        );
      },
    );
  }

  Future<Null> _refresh() {
    return _workTimeService.findAllByEmployeeIdAndDateIn(_employeeId, _date).then((res) {
      setState(() {
        _workTimes = res;
      });
    });
  }
}
