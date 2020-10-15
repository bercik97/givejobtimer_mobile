import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';

class ManagerPage extends StatefulWidget {
  final User _user;

  ManagerPage(this._user);

  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  User _user;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    return Container(child: Text('MANAGER PAGE'));
  }
}
