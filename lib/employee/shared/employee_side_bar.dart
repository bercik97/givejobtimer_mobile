import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/employee/employee_page.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/service/logout_service.dart';
import 'package:givejobtimer_mobile/shared/settings/settings_page.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/navigator_util.dart';
import 'package:open_appstore/open_appstore.dart';

Drawer employeeSideBar(BuildContext context, User user) {
  return Drawer(
    child: Container(
      color: DARK,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [WHITE, GREEN])),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 30,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage('images/logo.png'), fit: BoxFit.fill),
                    ),
                  ),
                  text25Dark(APP_NAME),
                ],
              ),
            ),
          ),
          ListTile(
            leading: iconWhite(Icons.person),
            title: text18White(getTranslated(context, 'profile')),
            onTap: () => NavigatorUtil.navigate(context, EmployeePage(user)),
          ),
          Divider(color: WHITE),
          ListTile(
            leading: iconWhite(Icons.star),
            title: text18White(getTranslated(context, 'rate')),
            onTap: () => OpenAppstore.launch(androidAppId: ANDROID_APP_ID, iOSAppId: IOS_APP_ID),
          ),
          ListTile(
            leading: iconWhite(Icons.settings),
            title: text18White(getTranslated(context, 'settings')),
            onTap: () => NavigatorUtil.navigate(context, SettingsPage(user)),
          ),
          ListTile(
            leading: iconWhite(Icons.exit_to_app),
            title: text18White(getTranslated(context, 'logout')),
            onTap: () => Logout.logout(context),
          ),
        ],
      ),
    ),
  );
}
