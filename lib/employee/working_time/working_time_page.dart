import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/workplace_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
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

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    _workplaceService = new WorkplaceService(_user.authHeader);
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(
            context, _user, getTranslated(context, 'manageYourWorkTime')),
        drawer: employeeSideBar(context, _user),
        body: SingleChildScrollView(
          child: Center(
            child: _buildStartTimeView(),
          ),
        ),
      ),
    );
  }

  Widget _buildStartTimeView() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: textCenter20Green(
              'Hint: Press start button and enter workplace code to begin work'),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: GREEN, width: 4),
            color: WHITE,
            shape: BoxShape.circle,
          ),
          child: BouncingWidget(
            duration: Duration(milliseconds: 100),
            scaleFactor: 2,
            onPressed: () => _showEnterWorkplaceCode(),
            child: Icon(
              Icons.play_arrow,
              size: 150,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[],
            ),
          ),
        ),
      ],
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
                          textCenter20GreenBold(
                              _workplaceCodeController.text + '?'),
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
                        onPressed: () => {},
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
}
