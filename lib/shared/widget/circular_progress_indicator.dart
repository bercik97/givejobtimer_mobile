import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';

Widget circularProgressIndicator() {
  return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(GREEN)));
}
