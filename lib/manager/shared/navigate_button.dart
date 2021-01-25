import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/pages/groups/group/employees/employees_page.dart';
import 'package:givejobtimer_mobile/manager/pages/groups/group/workplace/workplace_page.dart';
import 'package:givejobtimer_mobile/manager/pages/profile/manager_profile_page.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';

Widget navigateButton(BuildContext context, User _user) {
  return SpeedDial(
    backgroundColor: GREEN,
    animatedIcon: AnimatedIcons.view_list,
    animatedIconTheme: IconThemeData(color: BRIGHTER_DARK),
    curve: Curves.bounceIn,
    children: [
      SpeedDialChild(
        backgroundColor: BRIGHTER_DARK,
        child: Image(image: AssetImage('images/big-manager-icon.png')),
        label: getTranslated(context, 'profile'),
        labelBackgroundColor: BRIGHTER_DARK,
        labelStyle: TextStyle(color: WHITE),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagerProfilePage(_user)),
          );
        },
      ),
      SpeedDialChild(
        backgroundColor: BRIGHTER_DARK,
        child: Image(image: AssetImage('images/small-employees-icon.png')),
        label: getTranslated(context, 'employees'),
        labelBackgroundColor: BRIGHTER_DARK,
        labelStyle: TextStyle(color: WHITE),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployeesPage(_user)),
          );
        },
      ),
      SpeedDialChild(
        backgroundColor: BRIGHTER_DARK,
        child: Image(image: AssetImage('images/small-workplace-icon.png')),
        label: getTranslated(context, 'workplaces'),
        labelBackgroundColor: BRIGHTER_DARK,
        labelStyle: TextStyle(color: WHITE),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkplacePage(_user)),
          );
        },
      ),
    ],
  );
}
