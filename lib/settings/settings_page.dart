import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/internationalization/model/language.dart';
import 'package:givejobtimer_mobile/shared/util/language_util.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/pdf_viewer_from_asset.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/shared/util/url_util.dart';

import '../main.dart';
import 'bug_report_dialog.dart';

class SettingsPage extends StatefulWidget {
  final User _user;

  SettingsPage(this._user);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Language> _languages = LanguageUtil.getLanguages();
  List<DropdownMenuItem<Language>> _dropdownMenuItems;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_languages);
  }

  List<DropdownMenuItem<Language>> buildDropdownMenuItems(List languages) {
    List<DropdownMenuItem<Language>> items = List();
    for (Language language in languages) {
      items.add(
        DropdownMenuItem(value: language, child: Text(language.name + ' ' + language.flag)),
      );
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
      });
    }

    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, widget._user, getTranslated(context, 'settings')),
        drawer: widget._user.role == ROLE_EMPLOYEE ? employeeSideBar(context, widget._user) : managerSideBar(context, widget._user),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20, left: 15),
              child: Theme(
                data: Theme.of(context).copyWith(canvasColor: DARK),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: BRIGHTER_DARK)),
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  height: 30,
                  child: (DropdownButtonHideUnderline(
                      child: DropdownButton(
                          style: TextStyle(color: Colors.white, fontSize: 22),
                          hint: text16White(getTranslated(context, 'language')),
                          items: _dropdownMenuItems,
                          onChanged: (Language language) => {
                                _changeLanguage(language, context),
                              }))),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) => PDFViewerFromAsset(
                            title: getTranslated(context, 'regulations'),
                            pdfAssetPath: 'docs/regulations.pdf',
                          ),
                        ),
                      );
                    },
                    child: _subtitleInkWellContainer(getTranslated(context, 'regulations')))),
            Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (_) => PDFViewerFromAsset(
                            title: getTranslated(context, 'privacyPolicy'),
                            pdfAssetPath: 'docs/privacy_policy.pdf',
                          ),
                        ),
                      );
                    },
                    child: _subtitleInkWellContainer(getTranslated(context, 'privacyPolicy')))),
            Container(margin: EdgeInsets.only(left: 15, top: 10), child: InkWell(onTap: () => bugReportDialog(context), child: _subtitleInkWellContainer(getTranslated(context, 'bugReport')))),
            Container(margin: EdgeInsets.only(left: 25), alignment: Alignment.centerLeft, height: 30, child: text13White(getTranslated(context, 'version') + ': 1.0.3')),
            _titleContainer(getTranslated(context, 'graphics')),
            _socialMediaInkWell('https://plumko.business.site/ ', 'Plumko', 'images/plumko-logo.png'),
            _titleContainer(getTranslated(context, 'followUs')),
            SizedBox(height: 5.0),
            _socialMediaInkWell('https://www.givejob.pl', 'GiveJob', 'images/logo.png'),
            _socialMediaInkWell('https://www.medica.givejob.pl', 'GiveJob Medica', 'images/givejob-medica-logo.png'),
            _socialMediaInkWell('https://www.facebook.com/givejobb', 'Facebook', 'images/facebook-logo.png'),
            _socialMediaInkWell('https://www.instagram.com/give_job', 'Instagram', 'images/instagram-logo.png'),
            _socialMediaInkWell('https://www.linkedin.com/company/give-job', 'Linkedin', 'images/linkedin-logo.png'),
          ],
        ),
      ),
    );
  }

  Container _titleContainer(String text) {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 7.5),
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      height: 60,
      child: text20GreenBold(text),
    );
  }

  Container _subtitleInkWellContainer(String text) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: BRIGHTER_DARK)),
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      height: 30,
      child: text16White(text),
    );
  }

  InkWell _socialMediaInkWell(String url, String text, String imagePath) {
    return InkWell(
      onTap: () async => UrlUtil.launchURL(this.context, url),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Align(child: text16White(text), alignment: Alignment(-1.05, 0)),
            leading: Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                child: Image(image: AssetImage(imagePath), fit: BoxFit.fitWidth),
              ),
            ),
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }
}
