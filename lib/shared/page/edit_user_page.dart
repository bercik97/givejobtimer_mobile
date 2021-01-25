import 'dart:convert';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/user/service/user_service.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/loader_container.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/dialog_service.dart';
import 'package:givejobtimer_mobile/shared/service/toastr_service.dart';
import 'package:givejobtimer_mobile/shared/util/language_util.dart';

import '../app_bar.dart';
import '../colors.dart';
import '../constants.dart';
import '../icons.dart';
import '../texts.dart';

class EditUserPage extends StatefulWidget {
  final User _user;

  EditUserPage(this._user);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  User _user;

  Map<String, Object> _fieldsValues;
  UserService _userService;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _companyName;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _viberController = TextEditingController();
  final TextEditingController _whatsAppController = TextEditingController();
  String _nationality;

  bool _loading;

  @override
  void initState() {
    this._loading = true;
    super.initState();
    this._user = widget._user;
    this._fieldsValues = new Map();
    this._userService = ServiceInitializer.initialize(context, _user.authHeader, UserService);
    this._nameController.text = _user.name;
    this._surnameController.text = _user.surname;
    this._nationality = _user.nationality;
    _userService.findUserAndCompanyFieldsValuesById(
      _user.id,
      [
        'name',
        'surname',
        'nationality',
        'phone',
        'viber',
        'whatsApp',
        'companyName',
      ],
    ).then(
      (res) => {
        setState(() {
          _loading = false;
          _fieldsValues = res;
          _nameController.text = utf8.decode((this._fieldsValues['name'].toString()).runes.toList());
          _surnameController.text = utf8.decode((this._fieldsValues['surname'].toString()).runes.toList());
          _nationality = this._fieldsValues['nationality'];
          _phoneController.text = this._fieldsValues['phone'];
          _viberController.text = this._fieldsValues['viber'];
          _whatsAppController.text = this._fieldsValues['whatsApp'];
          _companyName = this._fieldsValues['companyName'];
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isRoleManager = _user.role == ROLE_MANAGER;
    if (_loading) {
      return loader(appBar(context, _user, getTranslated(context, 'loading')), isRoleManager ? managerSideBar(context, _user) : employeeSideBar(context, _user));
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, _user, getTranslated(context, 'informationAboutYou')),
        drawer: isRoleManager ? managerSideBar(context, _user) : employeeSideBar(context, _user),
        body: Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
          child: Center(
            child: Form(
              autovalidate: true,
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _buildReadOnlySection(isRoleManager),
                          _buildBasicSection(),
                          _buildContactSection(),
                        ],
                      ),
                    ),
                  ),
                  _buildUpdateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlySection(bool isRoleManager) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
          title: text16GreenBold(getTranslated(context, 'companyName')),
          subtitle: text16White(utf8.decode(_companyName.runes.toList())),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
          title: text16GreenBold(getTranslated(context, 'role')),
          subtitle: text16White(isRoleManager ? getTranslated(context, 'manager') : getTranslated(context, 'employee')),
        ),
      ],
    );
  }

  Widget _buildBasicSection() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Align(alignment: Alignment.topLeft, child: text25GreenUnderline(getTranslated(context, 'editableSection'))),
        SizedBox(height: 20),
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
                {'display': 'Беларус ' + LanguageUtil.findFlagByNationality('BE'), 'value': 'BE'},
                {'display': 'English ' + LanguageUtil.findFlagByNationality('EN'), 'value': 'EN'},
                {'display': 'ქართული ' + LanguageUtil.findFlagByNationality('GE'), 'value': 'GE'},
                {'display': 'Polska ' + LanguageUtil.findFlagByNationality('PL'), 'value': 'PL'},
                {'display': 'русский ' + LanguageUtil.findFlagByNationality('RU'), 'value': 'RU'},
                {'display': 'Українська ' + LanguageUtil.findFlagByNationality('UK'), 'value': 'UK'},
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

  Widget _buildUpdateButton() {
    return Column(
      children: <Widget>[
        MaterialButton(
          elevation: 0,
          minWidth: double.maxFinite,
          height: 50,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            if (!_isValid()) {
              DialogService.showCustomDialog(
                context: context,
                titleWidget: textRed(getTranslated(context, 'error')),
                content: getTranslated(context, 'correctInvalidFields'),
              );
            } else {
              showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
              _userService.update(
                _user.id,
                {
                  "name": _nameController.text,
                  "surname": _surnameController.text,
                  "nationality": _nationality,
                  "phone": _phoneController.text,
                  "viber": _viberController.text,
                  "whatsApp": _whatsAppController.text,
                },
              ).then((res) {
                Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                  ToastService.showSuccessToast(getTranslated(context, 'successfullyUpdatedInformationAboutYou'));
                  _user.name = _nameController.text;
                  _user.surname = _surnameController.text;
                  _user.nationality = _nationality;
                });
              }).catchError(
                (onError) {
                  Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                    DialogService.showCustomDialog(
                      context: context,
                      titleWidget: textRed(getTranslated(context, 'error')),
                      content: getTranslated(context, 'smthWentWrong'),
                    );
                  });
                },
              );
            }
          },
          color: GREEN,
          child: text20White(getTranslated(context, 'update')),
          textColor: Colors.white,
        ),
      ],
    );
  }

  bool _isValid() {
    return formKey.currentState.validate();
  }
}
