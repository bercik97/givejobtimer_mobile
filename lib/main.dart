import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/own_upgrader_messages.dart';
import 'package:givejobtimer_mobile/unauthenticated/get_started_page.dart';
import 'package:givejobtimer_mobile/unauthenticated/login_page.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:upgrader/upgrader.dart';

import 'employee/employee_page.dart';
import 'internationalization/localization/demo_localization.dart';
import 'internationalization/localization/localization_constants.dart';
import 'manager/manager_page.dart';
import 'shared/own_http_overrides.dart';

final storage = new FlutterSecureStorage();

void main() {
  HttpOverrides.global = new OwnHttpOverrides();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  Future<Map<String, String>> get authOrEmpty async {
    var getStartedClick = await storage.read(key: 'getStartedClick');
    var auth = await storage.read(key: 'authorization');
    var id = await storage.read(key: 'id');
    var managerId = await storage.read(key: 'managerId');
    var managerPhone = await storage.read(key: 'managerPhone');
    var managerViber = await storage.read(key: 'managerViber');
    var managerWhatsApp = await storage.read(key: 'managerWhatsApp');
    var employeeId = await storage.read(key: 'employeeId');
    var role = await storage.read(key: 'role');
    var companyId = await storage.read(key: 'companyId');
    var companyName = await storage.read(key: 'companyName');
    var name = await storage.read(key: 'name');
    var surname = await storage.read(key: 'surname');
    var nationality = await storage.read(key: 'nationality');
    var phone = await storage.read(key: 'phone');
    var viber = await storage.read(key: 'viber');
    var whatsApp = await storage.read(key: 'whatsApp');
    Map<String, String> map = new Map();
    map['getStartedClick'] = getStartedClick;
    map['authorization'] = auth;
    map['id'] = id;
    map['managerId'] = managerId;
    map['managerPhone'] = managerPhone;
    map['managerViber'] = managerViber;
    map['managerWhatsApp'] = managerWhatsApp;
    map['employeeId'] = employeeId;
    map['role'] = role;
    map['companyId'] = companyId;
    map['companyName'] = companyName;
    map['name'] = name;
    map['surname'] = surname;
    map['nationality'] = nationality;
    map['phone'] = phone;
    map['viber'] = viber;
    map['whatsApp'] = whatsApp;
    return map.isNotEmpty ? map : null;
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(child: Center(child: CircularProgressIndicator()));
    } else {
      final appcastURL = 'https://givejob.pl/mobile-app/appcast_timer.xml';
      final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
      return MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
        locale: _locale,
        supportedLocales: [
          Locale('be', 'BY'),
          Locale('en', 'EN'),
          Locale('pt', 'PT'), // GEORGIA
          Locale('pl', 'PL'),
          Locale('ru', 'RU'),
          Locale('uk', 'UA'),
        ],
        debugShowMaterialGrid: false,
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          seconds: 3,
          image: new Image.asset('images/logo.png'),
          backgroundColor: DARK,
          photoSize: 50,
          loaderColor: GREEN,
          navigateAfterSeconds: FutureBuilder(
            future: authOrEmpty,
            builder: (context, snapshot) {
              Map<String, String> data = snapshot.data;
              if (data == null) {
                return GetStartedPage();
              }
              StatefulWidget pageToReturn;
              String getStartedClick = data['getStartedClick'];
              if (getStartedClick == null) {
                pageToReturn = GetStartedPage();
              }
              User user = new User().create(data);
              String role = user.role;
              if (role == ROLE_EMPLOYEE) {
                pageToReturn = EmployeePage(user);
              } else if (role == ROLE_MANAGER) {
                pageToReturn = ManagerPage(user);
              } else {
                pageToReturn = LoginPage();
              }
              return UpgradeAlert(
                appcastConfig: cfg,
                debugLogging: true,
                showLater: false,
                messages: OwnUpgraderMessages(
                  getTranslated(context, 'updateTitle'),
                  getTranslated(context, 'newVersionOfApp'),
                  getTranslated(context, 'prompt'),
                  getTranslated(context, 'ignore'),
                  getTranslated(context, 'updateNow'),
                ),
                child: pageToReturn,
              );
            },
          ),
        ),
      );
    }
  }
}
