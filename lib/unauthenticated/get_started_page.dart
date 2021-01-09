import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/shared/util/language_util.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';

import '../internationalization/model/language.dart';
import '../main.dart';
import 'login_page.dart';

class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  List<Language> _languages = LanguageUtil.getLanguages();
  List<DropdownMenuItem<Language>> _dropdownMenuItems;
  Language _selectedLanguage;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_languages);
    _selectedLanguage = _dropdownMenuItems[1].value;
    super.initState();
  }

  List<DropdownMenuItem<Language>> buildDropdownMenuItems(List languages) {
    List<DropdownMenuItem<Language>> items = List();
    for (Language language in languages) {
      items.add(DropdownMenuItem(value: language, child: Text(language.name + ' ' + language.flag)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    void _changeLanguage(Language language, BuildContext context) async {
      showProgressDialog(context: context, loadingText: getTranslated(context, 'loading'));
      Locale _temp = await setLocale(language.languageCode);
      Future.delayed(Duration(microseconds: 1), () => dismissProgressDialog()).whenComplete(() {
        MyApp.setLocale(context, _temp);
        setState(() => _selectedLanguage = language);
      });
    }

    return Scaffold(
      backgroundColor: DARK,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Image.asset('images/logo.png', height: 100),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            textCenter30White(getTranslated(context, 'getStartedTitle')),
            textCenter30White('$APP_NAME !'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(child: textCenter19White(getTranslated(context, 'getStartedDescription'))),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(child: textCenter19White(getTranslated(context, 'getStartedLanguage'))),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              child: Center(
                child: Theme(
                  data: Theme.of(context).copyWith(canvasColor: DARK),
                  child: Column(
                    children: <Widget>[
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          style: TextStyle(color: Colors.white, fontSize: 25),
                          value: _selectedLanguage,
                          items: _dropdownMenuItems,
                          onChanged: (Language language) => (_changeLanguage(language, context)),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            MaterialButton(
              elevation: 0,
              height: 50,
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                storage.write(key: 'getStartedClick', value: 'click');
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                      return LoginPage();
                    },
                    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                      return SlideTransition(
                        position: new Tween<Offset>(
                          begin: const Offset(-1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: new SlideTransition(
                            position: new Tween<Offset>(
                              begin: Offset.zero,
                              end: const Offset(-1.0, 0.0),
                            ).animate(secondaryAnimation),
                            child: child),
                      );
                    },
                  ),
                );
              },
              color: GREEN,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  text20White(getTranslated(context, 'getStarted')),
                  iconWhite(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
