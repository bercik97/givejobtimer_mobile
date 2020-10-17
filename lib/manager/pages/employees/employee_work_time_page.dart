import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/employee/dto/work_time_dto.dart';
import 'package:givejobtimer_mobile/employee/service/work_time_service.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/toastr.dart';
import 'package:givejobtimer_mobile/widget/circular_progress_indicator.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class EmployeeWorkTimePage extends StatefulWidget {
  final User _user;
  final int _employeeId;
  final String _employeeInfo;
  final String _date;

  EmployeeWorkTimePage(
      this._user, this._employeeId, this._employeeInfo, this._date);

  @override
  _EmployeeWorkTimePageState createState() => _EmployeeWorkTimePageState();
}

class _EmployeeWorkTimePageState extends State<EmployeeWorkTimePage> {
  User _user;
  int _employeeId;
  String _employeeInfo;
  String _date;
  WorkTimeService _workTimeService;

  List<WorkTimeDto> _workTimes = new List();
  Set<int> selectedIds = new Set();

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    this._employeeId = widget._employeeId;
    this._employeeInfo = widget._employeeInfo;
    this._date = widget._date;
    _workTimeService = new WorkTimeService(_user.authHeader);
    if (_workTimes.isEmpty) {
      return MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: DARK,
          appBar: appBar(this.context, _user, _employeeInfo + ' / ' + _date),
          drawer: managerSideBar(this.context, _user),
          body: SingleChildScrollView(
            child: FutureBuilder(
              future: _workTimeService.findAllByEmployeeIdAndDate(
                  _employeeId, _date),
              builder: (BuildContext context,
                  AsyncSnapshot<List<WorkTimeDto>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(child: circularProgressIndicator()),
                  );
                } else {
                  _workTimes = snapshot.data;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Theme(
                        data: Theme.of(this.context)
                            .copyWith(dividerColor: MORE_BRIGHTER_DARK),
                        child: DataTable(
                          columnSpacing: 45,
                          columns: [
                            DataColumn(
                                label: textWhiteBold(
                                    getTranslated(this.context, 'from'))),
                            DataColumn(
                                label: textWhiteBold(
                                    getTranslated(this.context, 'to'))),
                            DataColumn(
                                label: textWhiteBold(
                                    getTranslated(this.context, 'sum'))),
                            DataColumn(
                                label: textWhiteBold(getTranslated(
                                    this.context, 'workplaceId'))),
                          ],
                          rows: [
                            for (var workTime in _workTimes)
                              DataRow(
                                selected: selectedIds.contains(workTime.id),
                                onSelectChanged: (bool selected) {
                                  onSelectedRow(selected, workTime.id);
                                },
                                cells: [
                                  DataCell(textWhite(workTime.startTime)),
                                  DataCell(textWhite(workTime.endTime != null
                                      ? workTime.endTime
                                      : '-')),
                                  DataCell(textWhite(workTime.totalTime != null
                                      ? workTime.totalTime
                                      : '-')),
                                  DataCell(textWhite(
                                      workTime.workplaceId != null
                                          ? workTime.workplaceId
                                          : '-')),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
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
          appBar: appBar(this.context, _user, _employeeInfo + ' / ' + _date),
          drawer: employeeSideBar(this.context, _user),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Theme(
                data: Theme.of(this.context)
                    .copyWith(dividerColor: MORE_BRIGHTER_DARK),
                child: DataTable(
                  columnSpacing: 45,
                  columns: [
                    DataColumn(
                        label:
                            textWhiteBold(getTranslated(this.context, 'from'))),
                    DataColumn(
                        label:
                            textWhiteBold(getTranslated(this.context, 'to'))),
                    DataColumn(
                        label:
                            textWhiteBold(getTranslated(this.context, 'sum'))),
                    DataColumn(
                        label: textWhiteBold(
                            getTranslated(this.context, 'workplaceId'))),
                  ],
                  rows: [
                    for (var workTime in _workTimes)
                      DataRow(
                        selected: selectedIds.contains(workTime.id),
                        onSelectChanged: (bool selected) {
                          onSelectedRow(selected, workTime.id);
                        },
                        cells: [
                          DataCell(textWhite(workTime.startTime)),
                          DataCell(textWhite(workTime.endTime != null
                              ? workTime.endTime
                              : '-')),
                          DataCell(textWhite(workTime.totalTime != null
                              ? workTime.totalTime
                              : '-')),
                          DataCell(textWhite(workTime.workplaceId != null
                              ? workTime.workplaceId
                              : '-')),
                        ],
                      ),
                  ],
                ),
              ),
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
    }
  }

  void onSelectedRow(bool selected, int id) {
    setState(() {
      selected ? selectedIds.add(id) : selectedIds.remove(id);
    });
  }

  _deleteByIdIn(Set<int> ids) {
    if (ids.isEmpty) {
      _showHint();
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textWhite(getTranslated(this.context, 'confirmation')),
          content: textWhite(getTranslated(
              this.context, 'areYouSureYouWantToDeleteSelectedWorkTimes')),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(this.context, 'yesDeleteThem')),
              onPressed: () => {
                _workTimeService
                    .deleteByIdIn(ids.toList())
                    .then((res) => {
                          Navigator.pop(this.context),
                          _refresh(),
                          ToastService.showSuccessToast(getTranslated(
                              this.context, 'selectedWorkTimesRemoved')),
                        })
                    .catchError((onError) {
                  ToastService.showErrorToast(
                      getTranslated(this.context, 'smthWentWrong'));
                }),
              },
            ),
            FlatButton(
                child: textWhite(getTranslated(this.context, 'no')),
                onPressed: () => Navigator.of(this.context).pop()),
          ],
        );
      },
    );
  }

  void _showHint() {
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold(getTranslated(context, 'hint')),
            SizedBox(height: 10),
            textCenter20White(
                getTranslated(context, 'needToSelectWorkTimes') + ' '),
            textCenter20White(getTranslated(context, 'whichYouWantToRemove')),
          ],
        ),
      ),
    );
  }

  Future<Null> _refresh() {
    return _workTimeService
        .findAllByEmployeeIdAndDate(_employeeId, _date)
        .then((res) {
      setState(() {
        _workTimes = res;
      });
    });
  }
}
