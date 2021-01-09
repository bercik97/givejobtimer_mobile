import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtil {
  static Future<bool> onWillPopNavigate(BuildContext context, StatefulWidget page) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    return false;
  }
}
