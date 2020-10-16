import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';

class WorkingTimePage extends StatefulWidget {
  final User _user;

  WorkingTimePage(this._user);

  @override
  _WorkingTimePageState createState() => _WorkingTimePageState();
}

class _WorkingTimePageState extends State<WorkingTimePage> {
  User _user;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(
            context, _user, getTranslated(context, 'manageYourWorkTime')),
        drawer: employeeSideBar(context, _user),
      ),
    );
  }
}
