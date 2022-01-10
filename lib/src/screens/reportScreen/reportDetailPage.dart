import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportDetailPage extends StatefulWidget {
  final UserRepository _userRepository;
  final String _wid;
  final bool _type;
  final List _categories;
  const ReportDetailPage(
      {Key? key,
      required UserRepository userRepository,
      required String wid,
      required bool type,
      required List categories})
      : _userRepository = userRepository,
        _wid = wid,
        _type = type,
        _categories = categories,
        super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  UserRepository get _userRepository => widget._userRepository;
  String get _wid => widget._wid;
  bool get _type => widget._type;
  List get _categories => widget._categories;
  String _selectedLoop = "This month";
  List<String> _loop = ['Today', 'This week', 'This month'];

  Future openChangTime() async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context1) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppStyle.lightColor,
                borderRadius: AppStyle.mainBorder,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _loop.length,
                itemBuilder: (context1, index) {
                  return ListTile(
                    title: Text(_loop[index]),
                    trailing: _selectedLoop == _loop[index]
                        ? Icon(
                            Icons.check_circle,
                            color: AppStyle.blueColor,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedLoop = _loop[index];
                      });
                      Navigator.pop(context1);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: AppStyle.mainBorder,
                child: MaterialButton(
                  minWidth: double.infinity,
                  color: AppStyle.blueColor,
                  elevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppStyle.lightColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        AppBarBtn(
            onPressed: () {
              openChangTime();
            },
            isAlign: false,
            icon: Icons.schedule),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: AppStyle.mainPadding,
            right: AppStyle.mainPadding,
            bottom: AppStyle.mainPadding),
        child: SingleChildScrollView(
          child: FutureBuilder<QuerySnapshot>(
            // future: _userRepository.getTransactionsByType(_wid, _type),
            future: choice(_selectedLoop, _wid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // final List<DocumentSnapshot> documents =
                  //     snapshot.data!.docs;
                  num tong = 0;
                  final List storedocs = [];
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map a = document.data() as Map<String, dynamic>;
                    if (a['type'] == _type) {
                      tong += a['money'];
                      _categories.forEach((element) {
                        if (element['id'] == a['idCategory']) {
                          a['imgCategory'] = element['img'];
                          a['nameCategory'] = element['name'];
                        }
                      });
                      a['id'] = document.id;
                      storedocs.add(a);
                    }
                  }).toList();
                  return Column(
                    children: [
                      OptionContainer(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Expenses",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${AppStyle.moneyFormat.format(tong)} VNĐ',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: _type == true
                                    ? Color(0xffb57084)
                                    : Color(0xff69C5F6),
                              ),
                            ),
                            storedocs.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(AppUI.Iextraincome),
                                  )
                                : Container(
                                    child: SfCircularChart(
                                      borderWidth: 10,
                                      // borderColor: Colors.red,
                                      margin: EdgeInsets.zero,
                                      series: <CircularSeries>[
                                        DoughnutSeries<dynamic, String>(
                                            dataSource: storedocs,
                                            xValueMapper: (dynamic data, _) =>
                                                data['imgCategory'],
                                            yValueMapper: (dynamic data, _) =>
                                                data['money'],
                                            dataLabelMapper:
                                                (dynamic data, _) =>
                                                    data['nameCategory'],
                                            dataLabelSettings:
                                                DataLabelSettings(
                                                    builder: (data,
                                                        point,
                                                        series,
                                                        pointIndex,
                                                        seriesIndex) {
                                                      return Container(
                                                          height: 24.sp,
                                                          width: 24.sp,
                                                          child: Image.asset(data[
                                                              'imgCategory']));
                                                    },
                                                    isVisible: true,
                                                    labelPosition:
                                                        ChartDataLabelPosition
                                                            .outside,
                                                    useSeriesColor: true))
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                      GroupedListView<dynamic, String>(
                          shrinkWrap: true,
                          primary: false,
                          elements: storedocs,
                          // itemComparator: (item1, item2) => item1['money']
                          //     .compareTo(item2['money']), // optional
                          // useStickyGroupSeparators: true, // optional
                          // floatingHeader: false, // optional
                          // order: GroupedListOrder.ASC,
                          groupBy: (element) {
                            DateTime dt =
                                (element['createAt'] as Timestamp).toDate();
                            final d12 = DateFormat.yMMMMEEEEd().format(dt);
                            return d12;
                          },
                          groupSeparatorBuilder: (String value) {
                            List paths = value.split(',');
                            List paths2 = paths[1].toString().split(' ');
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    paths2[2],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.sp,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(paths[0]),
                                        Text('${paths2[1]} ${paths[2]}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemBuilder: (context, dynamic element) {
                            return OptionContainer(
                              margin: EdgeInsets.only(bottom: 4.0, top: 4.0),
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                onTap: () {},
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(element['imgCategory']),
                                  radius: 20.0,
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      element['nameCategory'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    Text(
                                      '${AppStyle.moneyFormat.format(element['money'])} ${element['currency']}',
                                      style: TextStyle(
                                        fontSize: 15.0.sp,
                                        color: element['type'] == true
                                            ? Color(0xffb57084)
                                            : Color(0xff5985b5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          // optional
                          ),
                    ],
                  );
                }
              } else if (snapshot.hasError) {
                return Text('no data');
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot> choice(String selected, String wid) async {
    DateTime _selectedStart = DateTime.now();
    DateTime _selectedEnd = DateTime.now();
    if (selected == 'Today') {
      return _userRepository.getTransactionsByDate(wid, DateTime.now());
    } else if (selected == 'This month') {
      _selectedStart = DateTime(_selectedStart.year, _selectedStart.month, 1);
      _selectedEnd = DateTime(_selectedStart.year, _selectedStart.month, 31);
    } else if (selected == 'This week') {
      _selectedStart =
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      _selectedEnd = DateTime.now()
          .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));
    }
    return _userRepository.getTransactionsByTypeRange(
        wid, true, _selectedStart, _selectedEnd);
  }
}
