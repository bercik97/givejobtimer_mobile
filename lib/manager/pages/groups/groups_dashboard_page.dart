import 'dart:convert';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:givejobtimer_mobile/api/group/dto/group_dashboard_dto.dart';
import 'package:givejobtimer_mobile/api/group/service/group_service.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/user/dto/create_user_employee_without_token_dto.dart';
import 'package:givejobtimer_mobile/api/user/service/user_service.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/pages/shared/group_model.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/loader_container.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/dialog_service.dart';
import 'package:givejobtimer_mobile/shared/service/logout_service.dart';
import 'package:givejobtimer_mobile/shared/service/toastr_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/language_util.dart';
import 'package:givejobtimer_mobile/shared/util/navigator_util.dart';
import 'package:givejobtimer_mobile/shared/widget/buttons.dart';

import 'group/group_page.dart';
import 'manage/add_group_employees_page.dart';
import 'manage/add_group_page.dart';
import 'manage/delete_group_employees_page.dart';

class GroupsDashboardPage extends StatefulWidget {
  final User _user;

  GroupsDashboardPage(this._user);

  @override
  _GroupsDashboardPageState createState() => _GroupsDashboardPageState();
}

class _GroupsDashboardPageState extends State<GroupsDashboardPage> {
  User _user;

  GroupService _groupService;
  UserService _userService;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<GroupDashboardDto> _groups = new List();
  ScrollController _scrollController = new ScrollController();

  final _nameController = new TextEditingController();
  final _surnameController = new TextEditingController();
  String _nationality = '';
  bool _isErrorMsgOfNationalityShouldBeShow = false;
  bool _isCreateEmployeeAccountButtonTapped = false;

  CreateUserEmployeeWithoutTokenDto dto;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    this._user = widget._user;
    this._groupService = ServiceInitializer.initialize(context, _user.authHeader, GroupService);
    this._userService = ServiceInitializer.initialize(context, _user.authHeader, UserService);
    this._loading = true;
    _groupService.findAllByCompanyId(_user.companyId).then((res) {
      setState(() {
        _groups = res;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loader(appBar(context, _user, getTranslated(context, 'loading')), managerSideBar(context, _user));
    }
    return WillPopScope(
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: DARK,
          appBar: appBar(context, _user, getTranslated(context, 'companyGroups')),
          drawer: managerSideBar(context, _user),
          body: _groups.isNotEmpty ? _handleGroups() : _handleNoGroups(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: GREEN,
            animatedIconTheme: IconThemeData(size: 22.0),
            curve: Curves.bounceIn,
            children: [
              SpeedDialChild(
                child: Icon(Icons.group_add_outlined, color: DARK),
                backgroundColor: GREEN,
                onTap: () => NavigatorUtil.navigate(this.context, AddGroupPage(_user)),
                label: getTranslated(context, 'createGroup'),
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                labelBackgroundColor: GREEN,
              ),
              SpeedDialChild(
                child: Icon(Icons.person_add, color: DARK),
                backgroundColor: GREEN,
                onTap: () => _createNewEmployeeAccount(),
                label: getTranslated(context, 'createNewEmployeeAccount'),
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                labelBackgroundColor: GREEN,
              ),
            ],
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  void _createNewEmployeeAccount() {
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: getTranslated(context, 'createNewEmployeeAccount'),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              backgroundColor: Colors.black12,
              body: Center(
                child: Form(
                  autovalidate: true,
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildTextField(
                          _nameController,
                          getTranslated(context, 'name'),
                          getTranslated(context, 'nameIsRequired'),
                          Icons.person_outline,
                        ),
                        _buildTextField(
                          _surnameController,
                          getTranslated(context, 'surname'),
                          getTranslated(context, 'surnameIsRequired'),
                          Icons.person_outline,
                        ),
                        Theme(
                          data: ThemeData(hintColor: Colors.white, splashColor: GREEN, colorScheme: ColorScheme.dark()),
                          child: Column(
                            children: <Widget>[
                              DropDownFormField(
                                titleText: getTranslated(context, 'nationality'),
                                hintText: getTranslated(context, 'nationalityIsRequired'),
                                validator: (value) {
                                  if (_isErrorMsgOfNationalityShouldBeShow || (_isCreateEmployeeAccountButtonTapped && value == null)) {
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
                        ),
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
                              onPressed: () {
                                _nameController.clear();
                                _surnameController.clear();
                                _nationality = '';
                                _isCreateEmployeeAccountButtonTapped = false;
                                Navigator.pop(context);
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
                              onPressed: () => _isCreateEmployeeAccountButtonTapped ? null : _handleCreateEmployeeAccountButton(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, String errorText, IconData icon) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: controller,
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: 26,
          style: TextStyle(color: WHITE),
          decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: WHITE, width: 2)), counterStyle: TextStyle(color: WHITE), border: OutlineInputBorder(), labelText: labelText, prefixIcon: iconWhite(icon), labelStyle: TextStyle(color: WHITE)),
          validator: RequiredValidator(errorText: errorText),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  _handleCreateEmployeeAccountButton() {
    setState(() => _isCreateEmployeeAccountButtonTapped = true);
    if (!_isValid()) {
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
      setState(() => _isCreateEmployeeAccountButtonTapped = false);
      return;
    }
    showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
    dto = new CreateUserEmployeeWithoutTokenDto(
      name: _nameController.text,
      surname: _surnameController.text,
      nationality: _nationality,
      companyId: int.parse(_user.companyId),
    );
    _userService.createUserEmployeeWithoutToken(dto).then((res) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        ToastService.showSuccessToast(getTranslated(context, 'employeeAccountHasBeenSuccessfullyCreated'));
        Navigator.pop(context);
        _nameController.clear();
        _surnameController.clear();
        setState(() {
          _nationality = '';
          _isErrorMsgOfNationalityShouldBeShow = false;
          _isCreateEmployeeAccountButtonTapped = false;
        });
      });
    }).catchError((onError) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        ToastService.showErrorToast(getTranslated(context, 'smthWentWrong'));
        setState(() => _isCreateEmployeeAccountButtonTapped = false);
      });
    });
  }

  bool _isValid() {
    return formKey.currentState.validate();
  }

  Widget _handleGroups() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Tab(
              icon: Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 13),
                  child: Container(
                    child: Image(
                      width: 75,
                      image: AssetImage(
                        'images/company-icon.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            title: text18WhiteBold(
              _user.companyName != null ? utf8.decode(_user.companyName.runes.toList()) : getTranslated(context, 'empty'),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _groups.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: DARK,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          color: BRIGHTER_DARK,
                          child: ListTile(
                            onTap: () {
                              GroupDashboardDto group = _groups[index];
                              NavigatorUtil.navigate(
                                this.context,
                                GroupPage(GroupModel(_user, group.id, group.name, group.description, group.numberOfEmployees.toString())),
                              );
                            },
                            title: text18WhiteBold(
                              utf8.decode(
                                _groups[index].name != null ? _groups[index].name.runes.toList() : getTranslated(this.context, 'empty'),
                              ),
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                SizedBox(height: 5),
                                Align(
                                  child: textWhite(getTranslated(this.context, 'numberOfEmployees') + ': ' + _groups[index].numberOfEmployees.toString()),
                                  alignment: Alignment.topLeft,
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: icon30Green(Icons.emoji_people),
                                  onPressed: () => _manageGroupEmployees(_groups[index].name, _groups[index].id),
                                ),
                                SizedBox(width: 20),
                                IconButton(
                                  icon: icon30Red(Icons.delete),
                                  onPressed: () => _showDeleteGroupDialog(_groups[index].name),
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
        ],
      ),
    );
  }

  Widget _handleNoGroups() {
    String info = utf8.decode((_user.name + ' ' + _user.surname).runes.toList());
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Align(
            alignment: Alignment.center,
            child: text20GreenBold(getTranslated(context, 'welcome') + ' ' + info),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 30, left: 30, top: 10),
          child: Align(
            alignment: Alignment.center,
            child: textCenter19White(getTranslated(context, 'loggedSuccessButNoGroups')),
          ),
        ),
      ],
    );
  }

  void _manageGroupEmployees(String groupName, int groupId) {
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: getTranslated(context, 'manageGroupEmployees'),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Form(
                autovalidate: true,
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: text20GreenBold(getTranslated(context, 'manageGroupEmployees')),
                    ),
                    SizedBox(height: 2.5),
                    textWhite(utf8.decode(groupName.runes.toList())),
                    SizedBox(height: 20),
                    Buttons.standardButton(
                      minWidth: 200.0,
                      color: GREEN,
                      title: getTranslated(context, 'addEmployees'),
                      fun: () => NavigatorUtil.navigate(this.context, AddGroupEmployeesPage(_user, groupId)),
                    ),
                    Buttons.standardButton(
                      minWidth: 200.0,
                      color: Colors.red,
                      title: getTranslated(context, 'deleteEmployees'),
                      fun: () => NavigatorUtil.navigate(this.context, DeleteGroupEmployeesPage(_user, groupId)),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 80,
                      child: MaterialButton(
                        elevation: 0,
                        height: 50,
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.close)],
                        ),
                        color: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteGroupDialog(String groupName) {
    TextEditingController _nameController = new TextEditingController();
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: getTranslated(context, 'deleteGroup'),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Form(
                autovalidate: true,
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: text20RedBold(getTranslated(context, 'deleteGroup')),
                    ),
                    SizedBox(height: 2.5),
                    textRed(utf8.decode(groupName.runes.toList())),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: TextFormField(
                        autofocus: true,
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        maxLength: 26,
                        maxLines: 1,
                        cursorColor: WHITE,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: WHITE),
                        decoration: InputDecoration(
                          hintText: getTranslated(context, 'textGroupNameForDelete'),
                          hintStyle: TextStyle(color: MORE_BRIGHTER_DARK),
                          counterStyle: TextStyle(color: WHITE),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: WHITE, width: 2)),
                        ),
                        validator: (value) => _validateGroupName(value, groupName),
                      ),
                    ),
                    SizedBox(height: 10),
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
                          onPressed: () => Navigator.pop(context),
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
                            if (!_isValid()) {
                              DialogService.showCustomDialog(
                                context: context,
                                titleWidget: textRed(getTranslated(context, 'error')),
                                content: getTranslated(context, 'correctInvalidFields'),
                              );
                              return;
                            }
                            showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
                            _groupService.deleteByName(_nameController.text).then((value) {
                              Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                                ToastService.showSuccessToast(getTranslated(context, 'successfullyDeletedGroup'));
                                NavigatorUtil.navigate(context, GroupsDashboardPage(_user));
                              });
                            }).catchError((onError) {
                              Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                                String errorMsg = onError.toString();
                                if (errorMsg.contains("GROUP_DOES_NOT_EXISTS")) {
                                  DialogService.showCustomDialog(
                                    context: context,
                                    titleWidget: textRed(getTranslated(context, 'error')),
                                    content: getTranslated(context, 'groupDoesNotExists'),
                                  );
                                }
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
          ),
        );
      },
    );
  }

  _validateGroupName(String value, String groupName) {
    return value != utf8.decode(groupName.runes.toList()) ? getTranslated(context, 'groupNameForDeleteInvalid') : null;
  }

  Future<bool> _onWillPop() async {
    return Logout.logout(context) ?? false;
  }
}
