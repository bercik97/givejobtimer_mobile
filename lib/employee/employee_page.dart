import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';

class EmployeePage extends StatefulWidget {
  final User _user;

  EmployeePage(this._user);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  User _user;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    return Container(child: Text('EMPLOYEE PAGE'));
  }
}
