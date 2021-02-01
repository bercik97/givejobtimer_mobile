import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/work_time/dto/work_time_employee_dto.dart';
import 'package:givejobtimer_mobile/api/work_time/service/work_time_service.dart';
import 'package:givejobtimer_mobile/api/workplace/dto/workplace_dates_dto.dart';
import 'package:givejobtimer_mobile/api/workplace/dto/workplace_dto.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/widget/circular_progress_indicator.dart';

class WorkplaceWorkTimePage extends StatefulWidget {
  final User _user;
  final WorkplaceDatesDto _workplace;
  final WorkplaceDto _workplaceDto;

  WorkplaceWorkTimePage(this._user, this._workplace, this._workplaceDto);

  @override
  _WorkplaceWorkTimePageState createState() => _WorkplaceWorkTimePageState();
}

class _WorkplaceWorkTimePageState extends State<WorkplaceWorkTimePage> {
  User _user;
  WorkplaceDatesDto _workplace;
  WorkplaceDto _workplaceDto;

  WorkTimeService _workTimeService;

  List<WorkTimeEmployeeDto> _workTimes = new List();

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    this._workplace = widget._workplace;
    this._workplaceDto = widget._workplaceDto;
    this._workTimeService = ServiceInitializer.initialize(context, _user.authHeader, WorkTimeService);
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(this.context, _user, _workplace.year + ' ' + getTranslated(this.context, _workplace.month)),
        drawer: managerSideBar(this.context, _user),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Column(
                  children: [
                    ListTile(
                      title: text20White(getTranslated(this.context, 'code')),
                      subtitle: text20GreenBold(_workplaceDto.id),
                    ),
                    ListTile(
                      title: text20White(getTranslated(this.context, 'workplace')),
                      subtitle: text20GreenBold(utf8.decode(_workplaceDto.name.runes.toList())),
                    ),
                    ListTile(
                      title: text20White(getTranslated(this.context, 'totalTimeWorked')),
                      subtitle: text20GreenBold(_workplace.totalDateTime),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _workTimeService.findAllDatesWithTotalTimeByWorkplaceIdAndYearMonthIn(_workplaceDto.id, _workplace.year + '-' + _workplace.month),
                builder: (BuildContext context, AsyncSnapshot<List<WorkTimeEmployeeDto>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                    return Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: circularProgressIndicator(),
                    );
                  } else {
                    _workTimes = snapshot.data;
                    return SingleChildScrollView(
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
                              DataColumn(label: textWhiteBold(getTranslated(this.context, 'employee'))),
                            ],
                            rows: [
                              for (var workTime in _workTimes)
                                DataRow(
                                  cells: [
                                    DataCell(textWhite(workTime.date)),
                                    DataCell(textWhite(workTime.startTime)),
                                    DataCell(textWhite(workTime.endTime != null ? workTime.endTime : '-')),
                                    DataCell(textWhite(workTime.totalTime != null ? workTime.totalTime : '-')),
                                    DataCell(textWhite(workTime.employeeInfo != null ? utf8.decode(workTime.employeeInfo.runes.toList()) : '-')),
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
            ],
          ),
        ),
      ),
    );
  }
}
