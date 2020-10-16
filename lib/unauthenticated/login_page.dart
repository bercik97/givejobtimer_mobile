import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givejobtimer_mobile/employee/employee_page.dart';
import 'package:givejobtimer_mobile/manager/manager_page.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/toastr.dart';
import 'package:givejobtimer_mobile/shared/validator.dart';
import 'package:givejobtimer_mobile/unauthenticated/registration_page.dart';
import 'package:givejobtimer_mobile/unauthenticated/service/token_service.dart';
import 'package:givejobtimer_mobile/widget/circular_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../internationalization/localization/localization_constants.dart';
import '../main.dart';
import 'get_started_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TokenService _tokenService = TokenService();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _loginCodeController = TextEditingController();

  bool _loginCodeVisible = false;

  @override
  void initState() {
    _loginCodeVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: '  ' + getTranslated(context, 'loading'),
      messageTextStyle: TextStyle(color: DARK),
      progressWidget: circularProgressIndicator(),
    );

    return Scaffold(
      backgroundColor: DARK,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: iconWhite(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute<Null>(
                builder: (BuildContext context) {
                  return GetStartedPage();
                },
              ),
            );
          },
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            textCenter28White(getTranslated(context, 'loginTitle')),
            SizedBox(height: 20),
            textCenter14White(getTranslated(context, 'loginDescription')),
            SizedBox(height: 50),
            _buildUniqueCodeField(),
            SizedBox(height: 30),
            MaterialButton(
              elevation: 0,
              minWidth: double.maxFinite,
              height: 50,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                String loginCode = _loginCodeController.text;
                String invalidMessage =
                    ValidatorService.validateLoginCode(loginCode, context);
                if (invalidMessage != null) {
                  ToastService.showErrorToast(invalidMessage);
                  return;
                }
                progressDialog.show();
                _login(_loginCodeController.text).then((res) {
                  FocusScope.of(context).unfocus();
                  bool resNotNullOrEmpty = res.body != null && res.body != '{}';
                  if (res.statusCode == 200 && resNotNullOrEmpty) {
                    String authHeader = 'Basic ' +
                        base64Encode(utf8.encode('$loginCode:$loginCode'));
                    storage.write(key: 'authorization', value: authHeader);
                    Map map = json.decode(res.body);
                    User user = new User();
                    user.id = map['id'];
                    user.managerId = map['managerId'];
                    user.employeeId = map['employeeId'];
                    user.role = map['role'];
                    user.name = map['name'];
                    user.surname = map['surname'];
                    user.nationality = map['nationality'];
                    user.phone = map['phone'];
                    user.viber = map['viber'];
                    user.whatsApp = map['whatsApp'];
                    user.managerPhone = map['managerPhone'];
                    user.managerViber = map['managerViber'];
                    user.managerWhatsApp = map['managerWhatsApp'];
                    user.authHeader = authHeader;
                    storage.write(key: 'id', value: user.id.toString());
                    storage.write(
                        key: 'managerId', value: user.managerId.toString());
                    storage.write(
                        key: 'employeeId', value: user.employeeId.toString());
                    storage.write(key: 'role', value: user.role);
                    storage.write(key: 'name', value: user.name);
                    storage.write(key: 'surname', value: user.surname);
                    storage.write(key: 'nationality', value: user.nationality);
                    storage.write(key: 'phone', value: user.phone);
                    storage.write(key: 'viber', value: user.viber);
                    storage.write(key: 'whatsApp', value: user.whatsApp);
                    storage.write(
                        key: 'managerPhone', value: user.managerPhone);
                    storage.write(
                        key: 'managerViber', value: user.managerViber);
                    storage.write(
                        key: 'managerWhatsApp', value: user.managerWhatsApp);
                    if (user.role == ROLE_EMPLOYEE) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeePage(user)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManagerPage(user)));
                    }
                    ToastService.showSuccessToast(
                        getTranslated(context, 'loginSuccessfully'));
                  } else {
                    progressDialog.hide();
                    ToastService.showErrorToast(
                        getTranslated(context, 'wrongLoginCode'));
                  }
                }, onError: (e) {
                  progressDialog.hide();
                  ToastService.showErrorToast(
                      getTranslated(context, 'cannotConnectToServer'));
                });
              },
              color: GREEN,
              child: text20White(getTranslated(context, 'login')),
              textColor: Colors.white,
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () => _showCreateAccountDialog(),
              child: textCenter20WhiteBoldUnderline(
                  getTranslated(context, 'createNewAccount')),
            ),
            SizedBox(height: 100),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildFooterLogo(),
            )
          ],
        ),
      ),
    );
  }

  Future<http.Response> _login(String loginCode) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$loginCode:$loginCode'));
    var res = await http
        .get('$SERVER_IP/login', headers: {'authorization': basicAuth});
    return res;
  }

  _buildUniqueCodeField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DARK),
      ),
      child: TextField(
        controller: _loginCodeController,
        style: TextStyle(color: DARK),
        obscureText: !_loginCodeVisible,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: getTranslated(context, 'loginCode'),
          labelStyle: TextStyle(color: DARK),
          icon: iconDark(Icons.lock),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
                _loginCodeVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(
              () => _loginCodeVisible = !_loginCodeVisible,
            ),
          ),
        ),
      ),
    );
  }

  _showCreateAccountDialog() {
    return showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: getTranslated(context, 'createNewAccount'),
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
                      getTranslated(context, 'createNewAccountPopupTitle')),
                  SizedBox(height: 30),
                  PinCodeTextField(
                    autofocus: true,
                    highlight: true,
                    controller: _tokenController,
                    highlightColor: WHITE,
                    defaultBorderColor: MORE_BRIGHTER_DARK,
                    hasTextBorderColor: GREEN,
                    maxLength: 6,
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
                          _tokenController.clear(),
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
                            _tokenService
                                .findTokenRole(_tokenController.text)
                                .then(
                              (res) {
                                if (res == null) {
                                  _tokenAlertDialog(false, res);
                                  return;
                                }
                                _tokenAlertDialog(true, res);
                              },
                            ).catchError((onError) {
                              _tokenAlertDialog(false, null);
                            });
                          }),
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

  _tokenAlertDialog(bool isCorrect, String role) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: isCorrect
              ? textGreen(getTranslated(context, 'success'))
              : textWhite(getTranslated(context, 'failure')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                textWhite(isCorrect
                    ? _buildSuccessMessageForSpecificRoleToken(role)
                    : getTranslated(context, 'tokenIsIncorrect')),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 0,
              height: 50,
              minWidth: double.maxFinite,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: GREEN,
              child: isCorrect
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        text20White(getTranslated(context, 'continue')),
                        iconWhite(Icons.arrow_forward_ios)
                      ],
                    )
                  : text20WhiteBold(getTranslated(context, 'close')),
              onPressed: () {
                if (!isCorrect) {
                  Navigator.of(context).pop();
                  return;
                }
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return EmployeeRegistrationPage(
                          _tokenController.text, role);
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return SlideTransition(
                        position: new Tween<Offset>(
                          begin: const Offset(-1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: new SlideTransition(
                            position: new Tween<Offset>(
                              begin: Offset.zero,
                              end: const Offset(-1.0, 0.0),
                            ).animate(secondaryAnimation),
                            child: child),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  _buildSuccessMessageForSpecificRoleToken(String role) {
    String msg = getTranslated(context, 'tokenIsCorrect') + '\n\n';
    if (role == ROLE_MANAGER) {
      return msg + getTranslated(context, 'redirectToManagerRegistration');
    } else {
      return msg + getTranslated(context, 'redirectToEmployeeRegistration');
    }
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('images/logo.png', height: 40),
        SizedBox(width: 5),
        text20WhiteBold(APP_NAME),
      ],
    );
  }
}
