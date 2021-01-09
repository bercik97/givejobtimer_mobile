import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/work_time/dto/create_work_time_dto.dart';
import 'package:givejobtimer_mobile/api/work_time/dto/is_currently_at_work_with_work_times_dto.dart';
import 'package:givejobtimer_mobile/api/work_time/service/work_time_service.dart';
import 'package:givejobtimer_mobile/api/workplace/service/workplace_service.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/dialog_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/widget/circular_progress_indicator.dart';
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

  IsCurrentlyAtWorkWithWorkTimesDto _dto;

  bool _isStartButtonTapped = false;
  bool _isPauseButtonTapped = false;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    this._workplaceService = ServiceInitializer.initialize(context, _user.authHeader, WorkplaceService);
    _workTimeService = ServiceInitializer.initialize(context, _user.authHeader, WorkTimeService);
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, _user, getTranslated(context, 'workTimeForToday')),
        drawer: employeeSideBar(context, _user),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _workTimeService.checkIfIsCurrentlyAtWorkAndFindAllByEmployeeIdAndDateOrEndTimeIsNull(_user.employeeId),
            builder: (BuildContext context, AsyncSnapshot<IsCurrentlyAtWorkWithWorkTimesDto> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                return Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(child: circularProgressIndicator()),
                );
              } else {
                _dto = snapshot.data;
                List workTimes = _dto.workTimes;
                if (_dto.currentlyAtWork) {
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
          _buildBtn('images/stop-icon.png', _showPauseWorkDialog),
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
          _buildBtn('images/play-icon.png', _showEnterWorkplaceCode),
          _buildStartHint(),
          _displayWorkTimes(workTimes),
        ],
      ),
    );
  }

  Widget _buildBtn(String imgPath, Function() fun) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        BouncingWidget(
          duration: Duration(milliseconds: 100),
          scaleFactor: 2,
          onPressed: () => fun(),
          child: Image(width: 100, height: 100, image: AssetImage(imgPath)),
        ),
      ],
    );
  }

  Widget _buildStartHint() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: textCenter18Green(getTranslated(context, 'hintPressBtnToStart')),
    );
  }

  Widget _buildPauseHint() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: textCenter18Green(getTranslated(context, 'hintPressBtnToPause')),
    );
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
              children: <Widget>[textCenter20Green(getTranslated(context, 'pauseWorkConfirmation'))],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                FlatButton(
                  child: textWhite(getTranslated(context, 'workIsDone')),
                  onPressed: () => _isPauseButtonTapped ? null : _finishWork(),
                ),
                FlatButton(child: textWhite(getTranslated(context, 'no')), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ],
        );
      },
    );
  }

  _finishWork() {
    setState(() => _isPauseButtonTapped = !_isPauseButtonTapped);
    showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
    _workTimeService.finish(_dto.notFinishedWorkTimeId).then((res) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        _refresh();
        Navigator.pop(context);
        setState(() => _isStartButtonTapped = false);
      });
    }).catchError((onError) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        DialogService.showCustomDialog(
          context: context,
          titleWidget: textRed(getTranslated(context, 'error')),
          content: getTranslated(context, 'smthWentWrong'),
        );
        setState(() => _isStartButtonTapped = false);
      });
    });
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
                  textCenter20GreenBold(getTranslated(context, 'enterWorkplaceCodePopupTitle')),
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
                    pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                    pinTextStyle: TextStyle(fontSize: 22, color: WHITE),
                    pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
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
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
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
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.check)],
                        ),
                        color: GREEN,
                        onPressed: () {
                          showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
                          _workplaceService.isCorrectByIdAndManagerId(_workplaceCodeController.text, _user.managerId).then((res) {
                            Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                              Navigator.pop(context);
                              _resultWorkplaceCodeAlertDialog(res);
                            });
                          }).catchError((onError) {
                            Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                              DialogService.showCustomDialog(
                                context: context,
                                titleWidget: textRed(getTranslated(context, 'error')),
                                content: getTranslated(context, 'smthWentWrong'),
                              );
                              Navigator.pop(context);
                              _resultWorkplaceCodeAlertDialog(false);
                            });
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
    String workplaceId = _workplaceCodeController.text;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: isCorrect ? textGreen(getTranslated(context, 'correctWorkplaceCode')) : textWhite(getTranslated(context, 'failure')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                isCorrect
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textCenter20White(getTranslated(context, 'startTimeConfirmation')),
                          textCenter20GreenBold(workplaceId + '?'),
                        ],
                      )
                    : textWhite(getTranslated(context, 'workplaceCodeIsIncorrect'))
              ],
            ),
          ),
          actions: <Widget>[
            isCorrect
                ? Row(
                    children: [
                      FlatButton(
                        child: textWhite(getTranslated(context, 'yesImSure')),
                        onPressed: () => _isStartButtonTapped ? null : _startWork(workplaceId),
                      ),
                      FlatButton(child: textWhite(getTranslated(context, 'no')), onPressed: () => Navigator.of(context).pop()),
                    ],
                  )
                : MaterialButton(
                    elevation: 0,
                    height: 50,
                    minWidth: double.maxFinite,
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    color: GREEN,
                    child: text20WhiteBold(getTranslated(context, 'close')),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
          ],
        );
      },
    );
  }

  _startWork(String workplaceId) {
    setState(() => _isStartButtonTapped = !_isStartButtonTapped);
    CreateWorkTimeDto dto = new CreateWorkTimeDto(workplaceId: workplaceId, employeeId: int.parse(_user.employeeId));
    showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
    _workTimeService.create(dto).then((value) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        _refresh();
        Navigator.pop(context);
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

  _displayWorkTimes(List workTimes) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Theme(
          data: Theme.of(this.context).copyWith(dividerColor: MORE_BRIGHTER_DARK),
          child: DataTable(
            columnSpacing: 45,
            columns: [
              DataColumn(label: textWhiteBold(getTranslated(this.context, 'from'))),
              DataColumn(label: textWhiteBold(getTranslated(this.context, 'to'))),
              DataColumn(label: textWhiteBold(getTranslated(this.context, 'sum'))),
              DataColumn(label: textWhiteBold(getTranslated(this.context, 'workplaceId'))),
            ],
            rows: [
              for (var workTime in workTimes)
                DataRow(
                  cells: [
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
    );
  }

  Future<Null> _refresh() {
    return _workTimeService.checkIfIsCurrentlyAtWorkAndFindAllByEmployeeIdAndDateOrEndTimeIsNull(_user.employeeId).then((res) {
      setState(() => _dto = res);
    });
  }
}
