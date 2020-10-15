import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/internationalization/util/language_util.dart';
import 'package:givejobtimer_mobile/settings/documents_page.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/unauthenticated/service/register_service.dart';

import 'dto/create_user_dto.dart';
import 'login_page.dart';

class EmployeeRegistrationPage extends StatefulWidget {
  final String _tokenId;
  final String _role;

  EmployeeRegistrationPage(this._tokenId, this._role);

  @override
  _EmployeeRegistrationPageState createState() =>
      _EmployeeRegistrationPageState();
}

class _EmployeeRegistrationPageState extends State<EmployeeRegistrationPage> {
  CreateUserDto dto;
  RegisterService _registerService = RegisterService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _viberController = TextEditingController();
  final TextEditingController _whatsAppController = TextEditingController();
  String _nationality;
  bool _regulationsCheckbox = false;
  bool _privacyPolicyCheckbox = false;

  @override
  void initState() {
    super.initState();
    _nationality = '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget._tokenId == null) {
      return LoginPage();
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: DARK,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: iconWhite(Icons.arrow_back),
            onPressed: () => _exitDialog(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
          child: Center(
            child: Form(
              autovalidate: true,
              key: formKey,
              child: Column(
                children: <Widget>[
                  textCenter28GreenBold(
                      getTranslated(context, 'registrationForm')),
                  Divider(color: WHITE),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _buildLoginSection(),
                          _buildBasicSection(),
                          _buildContactSection(),
                          _buildDocumentsSection(),
                          _buildRegisterButton(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isValid() {
    return formKey.currentState.validate();
  }

  Widget _buildLoginSection() {
    return Align(
        alignment: Alignment.topLeft,
        child: textCenter20GreenBold(
            getTranslated(context, 'loginCodeWillBeDisplayed')));
  }

  Widget _buildBasicSection() {
    return Column(
      children: <Widget>[
        _buildSectionHeader(
          getTranslated(context, 'basicSection'),
          getTranslated(context, 'basicSectionDescription'),
        ),
        _buildRequiredTextField(
          _nameController,
          26,
          getTranslated(context, 'name'),
          getTranslated(context, 'nameIsRequired'),
          Icons.person_outline,
        ),
        _buildRequiredTextField(
          _surnameController,
          26,
          getTranslated(context, 'surname'),
          getTranslated(context, 'surnameIsRequired'),
          Icons.person_outline,
        ),
        _buildNationalityDropdown(),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      children: <Widget>[
        _buildSectionHeader(
          getTranslated(context, 'contactSection'),
          getTranslated(context, 'contactSectionDescription'),
        ),
        _buildContactNumField(
          _phoneController,
          getTranslated(context, 'phone'),
          Icons.phone,
        ),
        _buildContactNumField(
          _viberController,
          getTranslated(context, 'viber'),
          Icons.phone_in_talk,
        ),
        _buildContactNumField(
          _whatsAppController,
          getTranslated(context, 'whatsApp'),
          Icons.perm_phone_msg,
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      children: <Widget>[
        _buildSectionHeader(
          getTranslated(context, 'termsOfUse'),
          getTranslated(context, 'termsOfUseIsRequired'),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute<Null>(
                builder: (BuildContext context) {
                  return DocumentsPage();
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: textWhite(
                  getTranslated(context, 'seeDocumentsHint'),
                ),
              ),
              SizedBox(height: 1),
              Align(
                alignment: Alignment.topLeft,
                child: textWhiteBoldUnderline(
                  getTranslated(context, 'seeDocuments'),
                ),
              )
            ],
          ),
        ),
        ListTileTheme(
          contentPadding: EdgeInsets.all(0),
          child: CheckboxListTile(
            title: textWhite(
              getTranslated(context, 'acceptRegulations'),
            ),
            subtitle: !_regulationsCheckbox
                ? text13Red(
                    getTranslated(context, 'acceptRegulationsIsRequired'),
                  )
                : null,
            value: _regulationsCheckbox,
            onChanged: (value) {
              setState(() {
                _regulationsCheckbox = value;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        ListTileTheme(
          contentPadding: EdgeInsets.all(0),
          child: CheckboxListTile(
            title: textWhite(
              getTranslated(context, 'acceptPrivacyPolicy'),
            ),
            subtitle: !_privacyPolicyCheckbox
                ? text13Red(
                    getTranslated(context, 'acceptPrivacyPolicyIsRequired'),
                  )
                : null,
            value: _privacyPolicyCheckbox,
            onChanged: (value) {
              setState(() {
                _privacyPolicyCheckbox = value;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        )
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15),
        Align(alignment: Alignment.topLeft, child: text25GreenUnderline(title)),
        SizedBox(height: 5),
        Align(alignment: Alignment.topLeft, child: text13White(subtitle)),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRequiredTextField(TextEditingController controller,
      int maxLength, String labelText, String errorText, IconData icon) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: controller,
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: maxLength,
          style: TextStyle(color: WHITE),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WHITE, width: 2)),
              counterStyle: TextStyle(color: WHITE),
              border: OutlineInputBorder(),
              labelText: labelText,
              prefixIcon: iconWhite(icon),
              labelStyle: TextStyle(color: WHITE)),
          validator: RequiredValidator(errorText: errorText),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildContactNumField(
      TextEditingController controller, String labelText, IconData icon) {
    String validate(String value) {
      String phone = _phoneController.text;
      String viber = _viberController.text;
      String whatsApp = _whatsAppController.text;
      if (phone.isNotEmpty || viber.isNotEmpty || whatsApp.isNotEmpty) {
        return null;
      }
      return getTranslated(context, 'oneOfThreeContactsIsRequired');
    }

    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: 15,
          controller: controller,
          style: TextStyle(color: WHITE),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WHITE, width: 2)),
              counterStyle: TextStyle(color: WHITE),
              border: OutlineInputBorder(),
              labelText: labelText,
              prefixIcon: iconWhite(icon),
              labelStyle: TextStyle(color: WHITE)),
          validator: (value) => validate(value),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildNationalityDropdown() {
    return Theme(
      data: ThemeData(hintColor: DARK, splashColor: GREEN),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: DropDownFormField(
              titleText: getTranslated(context, 'nationality'),
              hintText: getTranslated(context, 'nationalityIsRequired'),
              value: _nationality,
              onSaved: (value) {
                setState(() {
                  _nationality = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  _nationality = value;
                });
              },
              dataSource: [
                {
                  'display':
                      'Беларус ' + LanguageUtil.findFlagByNationality('BE'),
                  'value': 'BE'
                },
                {
                  'display':
                      'English ' + LanguageUtil.findFlagByNationality('EN'),
                  'value': 'EN'
                },
                {
                  'display':
                      'ქართული ' + LanguageUtil.findFlagByNationality('GE'),
                  'value': 'GE'
                },
                {
                  'display':
                      'Polska ' + LanguageUtil.findFlagByNationality('PL'),
                  'value': 'PL'
                },
                {
                  'display':
                      'русский ' + LanguageUtil.findFlagByNationality('RU'),
                  'value': 'RU'
                },
                {
                  'display':
                      'Українська ' + LanguageUtil.findFlagByNationality('UK'),
                  'value': 'UK'
                },
              ],
              textField: 'display',
              valueField: 'value',
              required: true,
              autovalidate: true,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Column(
      children: <Widget>[
        SizedBox(height: 30),
        MaterialButton(
          elevation: 0,
          minWidth: double.maxFinite,
          height: 50,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () => {
            if (!_isValid() || !_regulationsCheckbox || !_privacyPolicyCheckbox)
              {
                _errorDialog(getTranslated(context, 'correctInvalidFields')),
              }
            else
              {
                dto = new CreateUserDto(
                    name: _nameController.text,
                    surname: _surnameController.text,
                    nationality: _nationality,
                    phone: _phoneController.text,
                    viber: _viberController.text,
                    whatsApp: _whatsAppController.text,
                    tokenId: widget._tokenId,
                    role: widget._role),
                _registerService.registerUser(dto).then((res) {
                  _showSuccessDialog(res);
                }).catchError((onError) {
                  _errorDialog(
                    getTranslated(context, 'smthWentWrong'),
                  );
                }),
              }
          },
          color: GREEN,
          child: text20White(getTranslated(context, 'register')),
          textColor: Colors.white,
        ),
      ],
    );
  }

  _errorDialog(String content) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textGreen(getTranslated(context, 'error')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                textWhite(content),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(context, 'close')),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  _showSuccessDialog(String loginCode) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textGreen(getTranslated(this.context, 'success')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                textWhite(getTranslated(this.context, 'registerSuccess')),
                SizedBox(height: 10),
                text20GreenBold(
                    getTranslated(this.context, 'loginCode') + ': $loginCode'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(this.context, 'goToLoginPage')),
              onPressed: () => _resetAndOpenPage(),
            ),
          ],
        );
      },
    );
  }

  void _resetAndOpenPage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      ModalRoute.withName('/'),
    );
  }

  Future<bool> _onWillPop() async {
    return _exitDialog() ?? false;
  }

  _exitDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textGreen(getTranslated(context, 'confirmation')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                textWhite(getTranslated(context, 'exitRegistrationContent')),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(context, 'exitAgree')),
              onPressed: () =>
                  {Navigator.of(context).pop(), _resetAndOpenPage()},
            ),
            FlatButton(
              child: textWhite(getTranslated(context, 'no')),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
