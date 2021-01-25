import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/pages/groups/group/workplace/workplace_page.dart';
import 'package:givejobtimer_mobile/manager/pages/shared/group_model.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/navigator_util.dart';

import '../groups_dashboard_page.dart';
import 'edit/group_edit_page.dart';
import 'employees/employees_page.dart';

class GroupPage extends StatefulWidget {
  final GroupModel _model;

  GroupPage(this._model);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  GroupModel _model;
  User _user;

  @override
  Widget build(BuildContext context) {
    this._model = widget._model;
    this._user = _model.user;
    return WillPopScope(
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: DARK,
          appBar: appBar(context, _user, getTranslated(context, 'group') + ' - ' + utf8.decode(_model.groupName != null ? _model.groupName.runes.toList() : '-')),
          drawer: managerSideBar(context, _user),
          body: SingleChildScrollView(
            child: Padding(
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
                                'images/group-icon.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: text18WhiteBold(
                      utf8.decode(
                        _model.groupName != null ? _model.groupName.runes.toList() : getTranslated(context, 'empty'),
                      ),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Align(
                          child: textWhite(utf8.decode(_model.groupDescription != null ? _model.groupDescription.runes.toList() : getTranslated(context, 'empty'))),
                          alignment: Alignment.topLeft,
                        ),
                        SizedBox(height: 5),
                        Align(
                          child: textWhite(getTranslated(context, 'numberOfEmployees') + ': ' + _model.numberOfEmployees.toString()),
                          alignment: Alignment.topLeft,
                        ),
                      ],
                    ),
                    trailing: Ink(
                      decoration: ShapeDecoration(color: GREEN, shape: CircleBorder()),
                      child: IconButton(
                        icon: iconDark(Icons.border_color),
                        onPressed: () => NavigatorUtil.navigate(this.context, GroupEditPage(_model)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () => NavigatorUtil.navigate(context, GroupsDashboardPage(_user)),
                            child: _buildScrollableContainer('images/groups-icon.png', 'backToGroups', 'seeYourAllGroups'),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Material(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () => NavigatorUtil.navigate(context, EmployeesPage(_user)),
                            child: _buildScrollableContainer('images/big-employees-icon.png', 'employees', 'seeYourEmployees'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () => NavigatorUtil.navigate(context, WorkplacePage(_user)),
                            child: _buildScrollableContainer('images/big-workplace-icon.png', 'workplaces', 'manageWorkplaces'),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(child: Material(color: BRIGHTER_DARK))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: () => NavigatorUtil.onWillPopNavigate(context, GroupsDashboardPage(_user)),
    );
  }

  Widget _buildScrollableContainer(String imagePath, String title, String subtitle) {
    return Container(
      height: 170,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Image(height: 100, image: AssetImage(imagePath)),
            textCenter16WhiteBold(getTranslated(context, title)),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: textCenter13White(
                getTranslated(context, subtitle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
