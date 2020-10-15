import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';

class EmployeesPage extends StatefulWidget {
  User _user;

  EmployeesPage(this._user);

  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  User _user;

  @override
  Widget build(BuildContext context) {
    widget._user = widget._user;
    return Container(child: text20Green('EMPLOYEES PAGE'));
  }
}
