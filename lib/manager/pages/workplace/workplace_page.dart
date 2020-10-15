import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';

class WorkplacePage extends StatefulWidget {
  User _user;

  WorkplacePage(this._user);

  @override
  _WorkplacePageState createState() => _WorkplacePageState();
}

class _WorkplacePageState extends State<WorkplacePage> {
  User _user;

  @override
  Widget build(BuildContext context) {
    widget._user = widget._user;
    return Container(child: text20Green('WORKPLACE PAGE'));
  }
}
