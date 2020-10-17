import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/widget/circular_progress_indicator.dart';

import 'colors.dart';
import 'constants.dart';

Widget loaderContainer(BuildContext context, Widget appBar, Widget drawer) {
  return MaterialApp(
    title: APP_NAME,
    theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: DARK,
      appBar: appBar,
      drawer: drawer,
      body: circularProgressIndicator(),
    ),
  );
}
