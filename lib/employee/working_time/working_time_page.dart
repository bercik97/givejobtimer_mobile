import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/employee/dto/create_work_time_dto.dart';
import 'package:givejobtimer_mobile/employee/dto/is_currently_at_work_with_work_times_dto.dart';
import 'package:givejobtimer_mobile/employee/service/work_time_service.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/workplace_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/widget/circular_progress_indicator.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class WorkingTimePage extends StatefulWidget {
  final User _user;

  WorkingTimePage(this._user);

  @override
  _WorkingTimePageState createState() => _WorkingTimePageState();
}

class _WorkingTimePageState extends State<WorkingTimePage> {
  User _user;

  final _workplaceCodeController = TextEditingController();
  WorkplaceService _workplaceService;
  WorkTimeService _workTimeService;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    _workplaceService = new WorkplaceService(_user.authHeader);
    _workTimeService = new WorkTimeService(_user.authHeader);
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(
            context,
            _user,
            getTranslated(context, 'workTime') +
                ' / ' +
                DateTime.now().toString().substring(0, 10)),
        drawer: employeeSideBar(context, _user),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _workTimeService
                .checkIfIsCurrentlyAtWorkAndFindAllByEmployeeIdAndDateOrEndTimeIsNull(
                    _user.employeeId, DateTime.now()),
            builder: (BuildContext context,
                AsyncSnapshot<IsCurrentlyAtWorkWithWorkTimesDto> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data == null) {
                return Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(child: circularProgressIndicator()),
                );
              } else {
                IsCurrentlyAtWorkWithWorkTimesDto dto = snapshot.data;
                List workTimes = dto.workTimes;
                if (dto.currentlyAtWork) {
                  return _handleEmployeeInWork(workTimes);
                } else {
                  return _handleEmployeeNotInWork(workTimes);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _handleEmployeeInWork(List workTimes) {
    return Center(
      child: Column(
        children: [
          _buildBtn(Icons.pause, _showEnterWorkplaceCode),
          _buildPauseHint(),
          _displayWorkTimes(workTimes),
        ],
      ),
    );
  }

  Widget _handleEmployeeNotInWork(List workTimes) {
    return Center(
      child: Column(
        children: [
          _buildBtn(Icons.play_arrow, _showEnterWorkplaceCode),
          _buildStartHint(),
          _displayWorkTimes(workTimes),
        ],
      ),
    );
  }

  Widget _buildBtn(IconData icon, Function() fun) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: GREEN, width: 7.5),
            color: WHITE,
            shape: BoxShape.circle,
          ),
          child: BouncingWidget(
            duration: Duration(milliseconds: 100),
            scaleFactor: 2,
            onPressed: () => fun(),
            child: Icon(icon, size: 100),
          ),
        ),
      ],
    );
  }

  Widget _buildStartHint() {
    return Padding(
      padding: EdgeInsets.all(20),
      child:
          textCenter18Green(getTranslated(context, 'hintPressBtnToStart')),
    );
  }

  Widget _buildPauseHint() {
    return Padding(
      padding: EdgeInsets.all(20),
      child:
          textCenter18Green(getTranslated(context, 'hintPressBtnToPause')),
    );
  }

  _showEnterWorkplaceCode() {
    return showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: getTranslated(context, 'enterWorkplaceCode'),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  textCenter20GreenBold(
                      getTranslated(context, 'enterWorkplaceCodePopupTitle')),
                  SizedBox(height: 30),
                  PinCodeTextField(
                    autofocus: true,
                    highlight: true,
                    controller: _workplaceCodeController,
                    highlightColor: WHITE,
                    defaultBorderColor: MORE_BRIGHTER_DARK,
                    hasTextBorderColor: GREEN,
                    maxLength: 4,
                    pinBoxWidth: 50,
                    pinBoxHeight: 64,
                    pinBoxDecoration:
                        ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                    pinTextStyle: TextStyle(fontSize: 22, color: WHITE),
                    pinTextAnimatedSwitcherTransition:
                        ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration:
                        Duration(milliseconds: 300),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        minWidth: 40,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.close)],
                        ),
                        color: Colors.red,
                        onPressed: () => {
                          Navigator.pop(context),
                          _workplaceCodeController.clear(),
                        },
                      ),
                      SizedBox(width: 25),
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.check)],
                        ),
                        color: GREEN,
                        onPressed: () {
                          _workplaceService
                              .isCorrectByIdAndManagerId(
                                  _workplaceCodeController.text,
                                  _user.managerId)
                              .then(
                            (res) {
                              _resultWorkplaceCodeAlertDialog(res);
                            },
                          ).catchError((onError) {
                            _resultWorkplaceCodeAlertDialog(false);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _resultWorkplaceCodeAlertDialog(bool isCorrect) {
    CreateWorkTimeDto dto;
    String workplaceId = _workplaceCodeController.text;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: isCorrect
              ? textGreen(getTranslated(context, 'correctWorkplaceCode'))
              : textWhite(getTranslated(context, 'failure')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                isCorrect
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textCenter20White(
                              getTranslated(context, 'startTimeConfirmation')),
                          textCenter20GreenBold(workplaceId + '?'),
                        ],
                      )
                    : textWhite(
                        getTranslated(context, 'workplaceCodeIsIncorrect'))
              ],
            ),
          ),
          actions: <Widget>[
            isCorrect
                ? Row(
                    children: [
                      FlatButton(
                        child: textWhite(getTranslated(context, 'yesImSure')),
                        onPressed: () => {
                          dto = new CreateWorkTimeDto(
                              date: DateTime.now().toString().substring(0, 10),
                              startTime:
                                  DateTime.now().toString().substring(11, 19),
                              workplaceId: workplaceId,
                              employeeId: int.parse(_user.employeeId)),
                          _workTimeService.create(dto).then(
                                (value) => {
                                  Navigator.pop(context),
                                },
                              )
                        },
                      ),
                      FlatButton(
                          child: textWhite(getTranslated(context, 'no')),
                          onPressed: () => Navigator.of(context).pop()),
                    ],
                  )
                : MaterialButton(
                    elevation: 0,
                    height: 50,
                    minWidth: double.maxFinite,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: GREEN,
                    child: text20WhiteBold(getTranslated(context, 'close')),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
          ],
        );
      },
    );
  }

  _displayWorkTimes(List workTimes) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Theme(
          data:
              Theme.of(this.context).copyWith(dividerColor: MORE_BRIGHTER_DARK),
          child: DataTable(
            columns: [
              DataColumn(
                  label: textWhiteBold(getTranslated(this.context, 'from'))),
              DataColumn(
                  label: textWhiteBold(getTranslated(this.context, 'to'))),
              DataColumn(
                  label: textWhiteBold(getTranslated(this.context, 'sum'))),
              DataColumn(
                  label: textWhiteBold(
                      getTranslated(this.context, 'workplaceId'))),
            ],
            rows: [
              for (var workTime in workTimes)
                DataRow(
                  cells: [
                    DataCell(textWhite(workTime.startTime)),
                    DataCell(textWhite(
                        workTime.endTime != null ? workTime.startTime : '-')),
                    DataCell(textWhite(
                        workTime.totalTime != null ? workTime.totalTime : '-')),
                    DataCell(textWhite(workTime.workplaceId)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
