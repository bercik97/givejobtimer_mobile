import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';

class EmployeesAtWorkPage extends StatefulWidget {
  User _user;

  EmployeesAtWorkPage(this._user);

  @override
  _EmployeesAtWorkPageState createState() => _EmployeesAtWorkPageState();
}

class _EmployeesAtWorkPageState extends State<EmployeesAtWorkPage> {
  User _user;

  @override
  Widget build(BuildContext context) {
    widget._user = widget._user;
    return Container(child: text20Green('CURRENTLY WORKING EMPLOYEES PAGE'));
  }
}
