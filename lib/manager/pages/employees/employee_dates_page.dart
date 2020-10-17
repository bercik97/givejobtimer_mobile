import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/employee/service/work_time_service.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/dto/employee_dates_dto.dart';
import 'package:givejobtimer_mobile/manager/dto/employee_dto.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/manager/shared/navigate_button.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';

class EmployeeDatesPage extends StatefulWidget {
  final User _user;
  final EmployeeDto _employee;

  EmployeeDatesPage(this._user, this._employee);

  @override
  _EmployeeDatesPageState createState() => _EmployeeDatesPageState();
}

class _EmployeeDatesPageState extends State<EmployeeDatesPage> {
  WorkTimeService _workTimeService;

  User _user;
  EmployeeDto _employee;

  List<EmployeeDatesDto> _employeeDates = new List();
  List<EmployeeDatesDto> _filteredEmployeeDates = new List();
  bool _loading = false;

  @override
  void initState() {
    this._user = widget._user;
    this._employee = widget._employee;
    this._workTimeService = new WorkTimeService(_user.authHeader);
    super.initState();
    _loading = true;
    _workTimeService
        .findAllDatesWithTotalTimeByEmployeeId(_employee.employeeId)
        .then((res) {
      setState(() {
        _employeeDates = res;
        _filteredEmployeeDates = _employeeDates;
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
        appBar:
            appBar(context, _user, _employee.name + ' ' + _employee.surname),
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
                      _filteredEmployeeDates = _employeeDates
                          .where((e) => ((e.date + ' ' + e.totalDateTime)
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                          .toList();
                    },
                  );
                },
              ),
            ),
            _employeeDates.isNotEmpty
                ? Expanded(
                    child: RefreshIndicator(
                      color: DARK,
                      backgroundColor: WHITE,
                      onRefresh: _refresh,
                      child: ListView.builder(
                        itemCount: _filteredEmployeeDates.length,
                        itemBuilder: (BuildContext context, int index) {
                          EmployeeDatesDto employeeDates =
                              _filteredEmployeeDates[index];
                          return Card(
                            color: DARK,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                  color: BRIGHTER_DARK,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          title: text20WhiteBold(
                                              employeeDates.date),
                                          subtitle: Column(
                                            children: <Widget>[
                                              Align(
                                                  child: Row(
                                                    children: <Widget>[
                                                      textWhite(getTranslated(
                                                              this.context,
                                                              'totalTimeWorked') +
                                                          ': '),
                                                      textGreenBold(employeeDates
                                                                  .totalDateTime !=
                                                              null
                                                          ? employeeDates
                                                              .totalDateTime
                                                          : '00:00:00'),
                                                    ],
                                                  ),
                                                  alignment: Alignment.topLeft),
                                            ],
                                          ),
                                          onTap: () => {},
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
            child: text20GreenBold(getTranslated(context, 'noDaysWorked')),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child: textCenter19White(
                getTranslated(context, 'noDaysWorkedOfCurrentEmployee')),
          ),
        ),
      ],
    );
  }

  Future<Null> _refresh() {
    return _workTimeService
        .findAllDatesWithTotalTimeByEmployeeId(_employee.employeeId)
        .then((res) {
      setState(() {
        _employeeDates = res;
        _filteredEmployeeDates = _employeeDates;
        _loading = false;
      });
    });
  }
}
