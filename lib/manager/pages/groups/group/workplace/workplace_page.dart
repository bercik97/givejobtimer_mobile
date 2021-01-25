import 'dart:collection';
import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/workplace/dto/create_workplace_dto.dart';
import 'package:givejobtimer_mobile/api/workplace/dto/workplace_dto.dart';
import 'package:givejobtimer_mobile/api/workplace/service/workplace_service.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/pages/groups/group/workplace/workplace_dates_page.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/loader_container.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/dialog_service.dart';
import 'package:givejobtimer_mobile/shared/service/toastr_service.dart';
import 'package:givejobtimer_mobile/shared/service/validator_service.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/navigator_util.dart';
import 'package:givejobtimer_mobile/shared/widget/hint.dart';
import 'package:shimmer/shimmer.dart';

class WorkplacePage extends StatefulWidget {
  final User _user;

  WorkplacePage(this._user);

  @override
  _WorkplacePageState createState() => _WorkplacePageState();
}

class _WorkplacePageState extends State<WorkplacePage> {
  User _user;
  WorkplaceService _workplaceService;

  List<WorkplaceDto> _workplaces = new List();
  List<WorkplaceDto> _filteredWorkplaces = new List();

  bool _loading = false;
  bool _isChecked = false;
  List<bool> _checked = new List();
  LinkedHashSet<String> _selectedIds = new LinkedHashSet();

  bool _isAddButtonTapped = false;
  bool _isDeleteButtonTapped = false;

  @override
  void initState() {
    this._user = widget._user;
    this._workplaceService = ServiceInitializer.initialize(context, _user.authHeader, WorkplaceService);
    super.initState();
    _loading = true;
    _workplaceService.findAllByCompanyId(_user.companyId).then((res) {
      setState(() {
        _workplaces = res;
        _workplaces.forEach((e) => _checked.add(false));
        _filteredWorkplaces = _workplaces;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loader(appBar(context, _user, getTranslated(context, 'loading')), managerSideBar(context, _user));
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, _user, getTranslated(context, 'workplaces')),
        drawer: managerSideBar(context, _user),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: TextFormField(
                autofocus: false,
                autocorrect: true,
                cursorColor: WHITE,
                style: TextStyle(color: WHITE),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: WHITE, width: 2)),
                  counterStyle: TextStyle(color: WHITE),
                  border: OutlineInputBorder(),
                  labelText: getTranslated(context, 'search'),
                  prefixIcon: iconWhite(Icons.search),
                  labelStyle: TextStyle(color: WHITE),
                ),
                onChanged: (string) {
                  setState(
                    () {
                      _filteredWorkplaces = _workplaces.where((w) => ((w.name + w.id).toLowerCase().contains(string.toLowerCase()))).toList();
                    },
                  );
                },
              ),
            ),
            ListTileTheme(
              contentPadding: EdgeInsets.only(left: 3),
              child: CheckboxListTile(
                title: textWhite(getTranslated(this.context, 'selectUnselectAll')),
                value: _isChecked,
                activeColor: GREEN,
                checkColor: WHITE,
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                    List<bool> l = new List();
                    _checked.forEach((b) => l.add(value));
                    _checked = l;
                    if (value) {
                      _selectedIds.addAll(_filteredWorkplaces.map((e) => e.id));
                    } else
                      _selectedIds.clear();
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            if (_workplaces.isEmpty)
              _handleNoWorkplaces()
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredWorkplaces.length,
                  itemBuilder: (BuildContext context, int index) {
                    WorkplaceDto workplace = _filteredWorkplaces[index];
                    int foundIndex = 0;
                    for (int i = 0; i < _workplaces.length; i++) {
                      if (_workplaces[i].id == workplace.id) {
                        foundIndex = i;
                      }
                    }
                    String id = workplace.id;
                    String name = workplace.name;
                    String totalTimeWorked = workplace.totalTimeWorked;
                    if (name != null && name.length >= 30) {
                      name = name.substring(0, 30) + ' ...';
                    }
                    return Card(
                      color: DARK,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            color: BRIGHTER_DARK,
                            child: ListTileTheme(
                              contentPadding: EdgeInsets.only(right: 10),
                              child: CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.trailing,
                                secondary: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Shimmer.fromColors(
                                    baseColor: GREEN,
                                    highlightColor: WHITE,
                                    child: BouncingWidget(
                                      duration: Duration(milliseconds: 100),
                                      scaleFactor: 2,
                                      onPressed: () => NavigatorUtil.navigate(this.context, WorkplaceDatesPage(_user, workplace)),
                                      child: Image(image: AssetImage('images/big-workplace-icon.png')),
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    text18WhiteBold(getTranslated(this.context, 'code') + ': '),
                                    text18GreenBold(id),
                                    IconButton(
                                      icon: icon30Green(Icons.border_color),
                                      onPressed: () => _editWorkplace(workplace),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: textWhite(name != null ? utf8.decode(name.runes.toList()) : getTranslated(this.context, 'empty')),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: textWhite(
                                        getTranslated(this.context, 'totalTimeWorked') + ': ' + (totalTimeWorked != null ? totalTimeWorked : '00:00:00'),
                                      ),
                                    )
                                  ],
                                ),
                                activeColor: GREEN,
                                checkColor: WHITE,
                                value: _checked[foundIndex],
                                onChanged: (bool value) {
                                  setState(() {
                                    _checked[foundIndex] = value;
                                    if (value) {
                                      _selectedIds.add(_workplaces[foundIndex].id);
                                    } else {
                                      _selectedIds.remove(_workplaces[foundIndex].id);
                                    }
                                    int selectedIdsLength = _selectedIds.length;
                                    if (selectedIdsLength == _workplaces.length) {
                                      _isChecked = true;
                                    } else if (selectedIdsLength == 0) {
                                      _isChecked = false;
                                    }
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "plusBtn",
              tooltip: getTranslated(context, 'addWorkplace'),
              backgroundColor: GREEN,
              onPressed: () => _addWorkplace(context),
              child: text25Dark('+'),
            ),
            SizedBox(height: 15),
            FloatingActionButton(
              heroTag: "deleteBtn",
              tooltip: getTranslated(context, 'deleteSelectedWorkplaces'),
              backgroundColor: Colors.red,
              onPressed: () => _isDeleteButtonTapped ? null : _handleDeleteByIdIn(_selectedIds),
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  void _addWorkplace(BuildContext context) {
    TextEditingController _workplaceController = new TextEditingController();
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: getTranslated(context, 'workplace'),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 50), child: text20GreenBold(getTranslated(context, 'addWorkplace'))),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: TextFormField(
                      autofocus: true,
                      controller: _workplaceController,
                      keyboardType: TextInputType.multiline,
                      maxLength: 200,
                      maxLines: 5,
                      cursorColor: WHITE,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: WHITE),
                      decoration: InputDecoration(
                        hintText: getTranslated(this.context, 'textSomeWorkplace') + ' ...',
                        hintStyle: TextStyle(color: MORE_BRIGHTER_DARK),
                        counterStyle: TextStyle(color: WHITE),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: GREEN, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: GREEN, width: 2.5),
                        ),
                      ),
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
                        onPressed: () => _isAddButtonTapped ? null : _handleAddWorkplace(_workplaceController.text),
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

  _handleAddWorkplace(String workplace) {
    setState(() => _isAddButtonTapped = true);
    String invalidMessage = ValidatorService.validateWorkplace(workplace, context);
    if (invalidMessage != null) {
      setState(() => _isAddButtonTapped = false);
      ToastService.showErrorToast(invalidMessage);
      return;
    }
    CreateWorkplaceDto dto = new CreateWorkplaceDto(companyId: int.parse(_user.companyId), name: workplace);
    showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
    _workplaceService.create(dto).then((res) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        Navigator.pop(context);
        _refresh();
        _showSuccessDialog(res);
      });
    }).catchError((onError) {
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        DialogService.showCustomDialog(
          context: context,
          titleWidget: textRed(getTranslated(context, 'error')),
          content: getTranslated(context, 'smthWentWrong'),
        );
        setState(() => _isAddButtonTapped = false);
      });
    });
  }

  _handleDeleteByIdIn(LinkedHashSet<String> ids) {
    if (ids.isEmpty) {
      showHint(context, getTranslated(context, 'needToSelectWorkplaces') + ' ', getTranslated(context, 'whichYouWantToRemove'));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textWhite(getTranslated(this.context, 'confirmation')),
          content: textWhite(getTranslated(this.context, 'areYouSureYouWantToDeleteSelectedWorkplaces')),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(this.context, 'yesDeleteThem')),
              onPressed: () {
                showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
                _workplaceService.deleteByIdIn(ids.toList()).then((res) {
                  Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                    NavigatorUtil.navigateReplacement(context, WorkplacePage(_user));
                    ToastService.showSuccessToast(getTranslated(this.context, 'selectedWorkplacesRemoved'));
                  });
                }).catchError((onError) {
                  Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                    String errorMsg = onError.toString();
                    if (errorMsg.substring(0, 17) == "EMPLOYEES_IN_WORK") {
                      setState(() => _isDeleteButtonTapped = false);
                      Navigator.pop(this.context);
                      _showErrorDialog(errorMsg.substring(19));
                      return;
                    }
                    DialogService.showCustomDialog(
                      context: context,
                      titleWidget: textRed(getTranslated(context, 'error')),
                      content: getTranslated(context, 'smthWentWrong'),
                    );
                    setState(() => _isDeleteButtonTapped = false);
                  });
                });
              },
            ),
            FlatButton(
              child: textWhite(getTranslated(this.context, 'no')),
              onPressed: () => Navigator.of(this.context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String workplaceIds) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textWhite(getTranslated(context, 'failure')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textCenter20White(getTranslated(this.context, 'cannotDeleteWorkplaceWhenSomeoneWorkingThere')),
                    textCenter20GreenBold(workplaceIds),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
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

  void _editWorkplace(WorkplaceDto workplace) {
    TextEditingController _workplaceController = new TextEditingController();
    _workplaceController.text = utf8.decode(workplace.name.runes.toList());
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: getTranslated(context, 'name'),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 50), child: text20GreenBold(getTranslated(context, 'editWorkplace'))),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: TextFormField(
                      autofocus: true,
                      controller: _workplaceController,
                      keyboardType: TextInputType.multiline,
                      maxLength: 200,
                      maxLines: 5,
                      cursorColor: WHITE,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: WHITE),
                      decoration: InputDecoration(
                        hintText: getTranslated(context, 'textSomeWorkplace') + ' ...',
                        hintStyle: TextStyle(color: MORE_BRIGHTER_DARK),
                        counterStyle: TextStyle(color: WHITE),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: GREEN, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: GREEN, width: 2.5),
                        ),
                      ),
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
                          String name = _workplaceController.text;
                          String invalidMessage = ValidatorService.validateWorkplace(name, context);
                          if (invalidMessage != null) {
                            ToastService.showErrorToast(invalidMessage);
                            return;
                          }
                          showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
                          _workplaceService.update(workplace.id, {'name': name}).then((res) {
                            Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                              Navigator.pop(context);
                              _refresh();
                              ToastService.showSuccessToast(getTranslated(context, 'successfullyUpdatedWorkplace') + ' (' + workplace.id + ')');
                            });
                          }).catchError((onError) {
                            Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
                              DialogService.showCustomDialog(
                                context: context,
                                titleWidget: textRed(getTranslated(context, 'error')),
                                content: getTranslated(context, 'smthWentWrong'),
                              );
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

  _showSuccessDialog(String workplaceCode) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textGreen(getTranslated(this.context, 'success')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                textWhite(getTranslated(this.context, 'successfullyAddedNewWorkplace')),
                SizedBox(height: 10),
                text20GreenBold(getTranslated(this.context, 'code') + ': $workplaceCode'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(this.context, 'ok')),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _handleNoWorkplaces() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Align(alignment: Alignment.center, child: text20GreenBold(getTranslated(this.context, 'noWorkplaces'))),
        ),
        Padding(
          padding: EdgeInsets.only(right: 30, left: 30, top: 10),
          child: Align(alignment: Alignment.center, child: textCenter19White(getTranslated(this.context, 'noWorkplacesHint'))),
        ),
      ],
    );
  }

  Future<Null> _refresh() {
    _loading = true;
    return _workplaceService.findAllByCompanyId(_user.companyId).then((res) {
      setState(() {
        _isAddButtonTapped = false;
        _isDeleteButtonTapped = false;
        _workplaces = res;
        _workplaces.forEach((e) => _checked.add(false));
        _filteredWorkplaces = _workplaces;
        _loading = false;
      });
    });
  }
}
