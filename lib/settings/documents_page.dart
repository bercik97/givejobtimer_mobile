import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:givejobtimer_mobile/employee/shared/employee_side_bar.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';
import 'package:givejobtimer_mobile/widget/circular_progress_indicator.dart';

class DocumentsPage extends StatefulWidget {
  final User _user;

  DocumentsPage(this._user);

  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  bool _isLoading = true;
  bool _isInit = true;
  PDFDocument regulationsPDF;
  PDFDocument privacyPolicyPDF;

  @override
  Widget build(BuildContext context) {
    if (widget._user != null) {
      return _buildForAuthenticatedUser();
    } else {
      return _buildForNotAuthenticatedUser();
    }
  }

  Widget _buildForAuthenticatedUser() {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, widget._user,
            getTranslated(context, 'termsOfUseLowerCase')),
        drawer: widget._user.role == ROLE_EMPLOYEE
            ? employeeSideBar(context, widget._user)
            : managerSideBar(context, widget._user),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildForNotAuthenticatedUser() {
    return Scaffold(
      backgroundColor: DARK,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: iconWhite(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: _isInit
                ? textCenter28White(getTranslated(
                    context, 'pressButtonToChooseInterestedDocument'))
                : _isLoading
                    ? Center(child: circularProgressIndicator())
                    : PDFViewer(document: regulationsPDF),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: GREEN,
                child: Text(getTranslated(context, 'regulations')),
                onPressed: () => _loadRegulationsFromDocs(),
              ),
            ),
            Expanded(
              child: MaterialButton(
                color: GREEN,
                child: Text(getTranslated(context, 'privacyPolicy')),
                onPressed: () => _loadPrivacyPolicyFromDocs(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _loadRegulationsFromDocs() async {
    setState(() {
      _isInit = false;
      _isLoading = true;
    });
    regulationsPDF = await PDFDocument.fromAsset('docs/regulations.pdf');
    setState(() {
      _isLoading = false;
    });
  }

  void _loadPrivacyPolicyFromDocs() async {
    setState(() {
      _isInit = false;
      _isLoading = true;
    });
    regulationsPDF = await PDFDocument.fromAsset('docs/privacy_policy.pdf');
    setState(() {
      _isLoading = false;
    });
  }
}
