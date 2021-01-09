import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givejobtimer_mobile/api/shared/service_initializer.dart';
import 'package:givejobtimer_mobile/api/workplace/dto/workplace_dates_dto.dart';
import 'package:givejobtimer_mobile/api/workplace/dto/workplace_dto.dart';
import 'package:givejobtimer_mobile/api/workplace/service/workplace_service.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/manager/pages/workplace/workplace_work_time_page.dart';
import 'package:givejobtimer_mobile/manager/shared/manager_side_bar.dart';
import 'package:givejobtimer_mobile/manager/shared/navigate_button.dart';
import 'package:givejobtimer_mobile/shared/app_bar.dart';
import 'package:givejobtimer_mobile/shared/colors.dart';
import 'package:givejobtimer_mobile/shared/constants.dart';
import 'package:givejobtimer_mobile/shared/icons.dart';
import 'package:givejobtimer_mobile/shared/loader_container.dart';
import 'package:givejobtimer_mobile/shared/model/user.dart';
import 'package:givejobtimer_mobile/shared/texts.dart';

class WorkplaceDatesPage extends StatefulWidget {
  final User _user;
  final WorkplaceDto _workplace;

  WorkplaceDatesPage(this._user, this._workplace);

  @override
  _WorkplaceDatesPageState createState() => _WorkplaceDatesPageState();
}

class _WorkplaceDatesPageState extends State<WorkplaceDatesPage> {
  WorkplaceService _workplaceService;

  User _user;
  WorkplaceDto _workplace;

  List<WorkplaceDatesDto> _workplaceDates = new List();
  List<WorkplaceDatesDto> _filteredWorkplaceDates = new List();
  bool _loading = false;

  @override
  void initState() {
    this._user = widget._user;
    this._workplace = widget._workplace;
    this._workplaceService = ServiceInitializer.initialize(context, _user.authHeader, WorkplaceService);
    super.initState();
    _loading = true;
    _workplaceService.findAllDatesWithTotalTimeByWorkplaceId(_workplace.id).then((res) {
      setState(() {
        _workplaceDates = res;
        _filteredWorkplaceDates = _workplaceDates;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loader(appBar(context, _user, getTranslated(context, 'loading')), managerSideBar(context, _user));
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, _user, getTranslated(context, 'workplace') + ': ' + _workplace.id),
        drawer: managerSideBar(context, _user),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: TextFormField(
                autofocus: false,
                autocorrect: true,
                cursorColor: WHITE,
                style: TextStyle(color: WHITE),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: WHITE, width: 2)),
                  counterStyle: TextStyle(color: WHITE),
                  border: OutlineInputBorder(),
                  labelText: getTranslated(context, 'search'),
                  prefixIcon: iconWhite(Icons.search),
                  labelStyle: TextStyle(color: WHITE),
                ),
                onChanged: (string) {
                  setState(
                    () {
                      _filteredWorkplaceDates = _workplaceDates.where((w) => ((w.year + ' ' + w.month).toLowerCase().contains(string.toLowerCase()))).toList();
                    },
                  );
                },
              ),
            ),
            _workplaceDates.isNotEmpty
                ? Expanded(
                    child: RefreshIndicator(
                      color: DARK,
                      backgroundColor: WHITE,
                      onRefresh: _refresh,
                      child: ListView.builder(
                        itemCount: _filteredWorkplaceDates.length,
                        itemBuilder: (BuildContext context, int index) {
                          WorkplaceDatesDto workplaceDates = _filteredWorkplaceDates[index];
                          return Card(
                            color: DARK,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                  color: BRIGHTER_DARK,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          title: text20WhiteBold(workplaceDates.year + ' ' + getTranslated(this.context, workplaceDates.month)),
                                          subtitle: Column(
                                            children: <Widget>[
                                              Align(
                                                  child: Row(
                                                    children: <Widget>[
                                                      textWhite(getTranslated(this.context, 'totalTimeWorked') + ': '),
                                                      textGreenBold(workplaceDates.totalDateTime != null ? workplaceDates.totalDateTime : '00:00:00'),
                                                    ],
                                                  ),
                                                  alignment: Alignment.topLeft),
                                            ],
                                          ),
                                          onTap: () => {
                                            Navigator.of(this.context).push(
                                              CupertinoPageRoute<Null>(
                                                builder: (BuildContext context) {
                                                  return WorkplaceWorkTimePage(_user, workplaceDates, _workplace);
                                                },
                                              ),
                                            ),
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : _handleEmptyData()
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: navigateButton(context, _user),
      ),
    );
  }

  Widget _handleEmptyData() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child: text20GreenBold(getTranslated(context, 'noMonthsWorked')),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child: textCenter19White(getTranslated(context, 'noDaysWorkedInCurrentWorkplace')),
          ),
        ),
      ],
    );
  }

  Future<Null> _refresh() {
    return _workplaceService.findAllDatesWithTotalTimeByWorkplaceId(_workplace.id).then((res) {
      setState(() {
        _workplaceDates = res;
        _filteredWorkplaceDates = _workplaceDates;
        _loading = false;
      });
    });
  }
}
