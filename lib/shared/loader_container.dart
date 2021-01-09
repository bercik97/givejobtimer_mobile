import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/shared/widget/circular_progress_indicator.dart';

import 'colors.dart';
import 'constants.dart';

MaterialApp loader(AppBar appBar, Drawer drawer) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: APP_NAME,
    theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
    home: Scaffold(
      backgroundColor: DARK,
      appBar: appBar,
      drawer: drawer,
      body: Center(child: circularProgressIndicator()),
    ),
  );
}
