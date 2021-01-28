import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/user/service/user_service.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/pdf_viewer_from_asset.dart';
import 'package:givejobtimer_mobile/shared/service/dialog_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/language_util.dart';

import '../api/user/dto/create_user_dto.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final String _tokenId;
  final num _companyId;
  final String _companyName;
  final String _role;

  RegisterPage(this._tokenId, this._companyId, this._companyName, this._role);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CreateUserDto dto;
  UserService _userService;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isRegisterButtonTapped;

  String _tokenId;
  num _companyId;
  String _companyName;
  String _role;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _viberController = TextEditingController();
  final TextEditingController _whatsAppController = TextEditingController();

  String _nationality;
  bool _isErrorMsgOfNationalityShouldBeShow = false;
  bool _regulationsCheckbox = false;
  bool _privacyPolicyCheckbox = false;

  @override
  void initState() {
    super.initState();
    _userService = ServiceInitializer.initialize(context, null, UserService);
    _tokenId = widget._tokenId;
    _companyId = widget._companyId;
    _companyName = widget._companyName;
    _role = widget._role;
    _isRegisterButtonTapped = false;
    _nationality = '';
  }

  @override
  Widget build(BuildContext context) {
    if (_tokenId == null) {
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
          leading: IconButton(icon: iconWhite(Icons.arrow_back), onPressed: () => _exitDialog()),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Center(
            child: Form(
              autovalidate: true,
              key: formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _buildLoginSection(),
                          _buildReadOnlySection(),
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

  Widget _buildReadOnlySection() {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
          title: text16GreenBold(getTranslated(context, 'companyName')),
          subtitle: text16White(_companyName),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
          title: text16GreenBold(getTranslated(context, 'role')),
          subtitle: text16White(_role == 'ROLE_MANAGER' ? getTranslated(context, 'coordinator') : getTranslated(context, 'employee')),
        ),
      ],
    );
  }

  Widget _buildLoginSection() {
    return Align(
      alignment: Alignment.topLeft,
      child: textCenter20GreenBold(getTranslated(context, 'loginCodeWillBeDisplayed')),
    );
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
        ListTileTheme(
          contentPadding: EdgeInsets.all(0),
          child: CheckboxListTile(
            title: Row(
              children: [
                textWhite(getTranslated(context, 'accept') + ' '),
                GestureDetector(
                  child: textWhiteBoldUnderline(getTranslated(context, 'regulationsLowerCase')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => PDFViewerFromAsset(
                          title: getTranslated(context, 'regulations'),
                          pdfAssetPath: 'docs/regulations.pdf',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            subtitle: !_regulationsCheckbox ? text13Red(getTranslated(context, 'acceptRegulationsIsRequired')) : null,
            value: _regulationsCheckbox,
            onChanged: (value) => setState(() => _regulationsCheckbox = value),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        ListTileTheme(
          contentPadding: EdgeInsets.all(0),
          child: CheckboxListTile(
            title: Row(
              children: [
                textWhite(getTranslated(context, 'accept') + ' '),
                GestureDetector(
                  child: textWhiteBoldUnderline(getTranslated(context, 'privacyPolicyLowerCase')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) => PDFViewerFromAsset(
                          title: getTranslated(context, 'privacyPolicy'),
                          pdfAssetPath: 'docs/privacy_policy.pdf',
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            subtitle: !_privacyPolicyCheckbox ? text13Red(getTranslated(context, 'acceptPrivacyPolicyIsRequired')) : null,
            value: _privacyPolicyCheckbox,
            onChanged: (value) => setState(() => _privacyPolicyCheckbox = value),
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

  Widget _buildRequiredTextField(TextEditingController controller, int maxLength, String labelText, String errorText, IconData icon) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: controller,
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: maxLength,
          style: TextStyle(color: WHITE),
          decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: WHITE, width: 2)), counterStyle: TextStyle(color: WHITE), border: OutlineInputBorder(), labelText: labelText, prefixIcon: iconWhite(icon), labelStyle: TextStyle(color: WHITE)),
          validator: RequiredValidator(errorText: errorText),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildContactNumField(TextEditingController controller, String labelText, IconData icon) {
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
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
          decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: WHITE, width: 2)), counterStyle: TextStyle(color: WHITE), border: OutlineInputBorder(), labelText: labelText, prefixIcon: iconWhite(icon), labelStyle: TextStyle(color: WHITE)),
          validator: (value) => validate(value),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildNationalityDropdown() {
    return Theme(
      data: ThemeData(hintColor: Colors.white, splashColor: GREEN, colorScheme: ColorScheme.dark()),
      child: Column(
        children: <Widget>[
          DropDownFormField(
            titleText: getTranslated(context, 'nationality'),
            hintText: getTranslated(context, 'nationalityIsRequired'),
            validator: (value) {
              if (_isErrorMsgOfNationalityShouldBeShow || (_isRegisterButtonTapped && value == null)) {
                return getTranslated(context, 'nationalityIsRequired');
              }
              return null;
            },
            value: _nationality,
            onSaved: (value) {
              setState(() {
                _nationality = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _nationality = value;
                FocusScope.of(context).unfocus();
                _isErrorMsgOfNationalityShouldBeShow = false;
              });
            },
            dataSource: [
              {'display': 'English ' + LanguageUtil.findFlagByNationality('EN'), 'value': 'EN'},
              {'display': 'Polska ' + LanguageUtil.findFlagByNationality('PL'), 'value': 'PL'},
              {'display': 'Українська ' + LanguageUtil.findFlagByNationality('UK'), 'value': 'UK'},
            ],
            textField: 'display',
            valueField: 'value',
            required: true,
            autovalidate: true,
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
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () => _isRegisterButtonTapped ? null : _handleRegisterButton(),
          color: GREEN,
          child: text20White(getTranslated(context, 'register')),
          textColor: Colors.white,
        ),
      ],
    );
  }

  _handleRegisterButton() {
    setState(() => _isRegisterButtonTapped = true);
    if (!_isValid() || !_regulationsCheckbox || !_privacyPolicyCheckbox) {
      DialogService.showCustomDialog(
        context: context,
        titleWidget: textRed(getTranslated(context, 'error')),
        content: getTranslated(context, 'correctInvalidFields'),
      );
      if (_nationality == '') {
        setState(() => _isErrorMsgOfNationalityShouldBeShow = true);
      } else {
        setState(() => _isErrorMsgOfNationalityShouldBeShow = false);
      }
      setState(() => _isRegisterButtonTapped = false);
      return;
    }
    showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
    dto = new CreateUserDto(
      name: _nameController.text,
      surname: _surnameController.text,
      nationality: _nationality,
      phone: _phoneController.text,
      viber: _viberController.text,
      whatsApp: _whatsAppController.text,
      tokenId: _tokenId,
      companyId: _companyId,
      role: _role,
    );
    _userService.create(dto).then((res) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() => _showSuccessDialog(res));
    }).catchError((onError) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        _errorDialog(getTranslated(context, 'smthWentWrong'));
        setState(() => _isRegisterButtonTapped = false);
      });
    });
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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          child: AlertDialog(
            backgroundColor: DARK,
            title: textGreen(getTranslated(this.context, 'success')),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  textWhite(getTranslated(this.context, 'registerSuccess')),
                  SizedBox(height: 10),
                  text20GreenBold(getTranslated(this.context, 'loginCode') + ': $loginCode'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: textWhite(getTranslated(this.context, 'goToLoginPage')),
                onPressed: () => _resetAndOpenPage(),
              ),
            ],
          ),
          onWillPop: _navigateToLoginPage,
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

  Future<bool> _navigateToLoginPage() async {
    _resetAndOpenPage();
    return true;
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
              onPressed: () {
                Navigator.of(context).pop();
                _resetAndOpenPage();
              },
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
