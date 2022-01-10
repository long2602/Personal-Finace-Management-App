import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/reportScreen/reportDetailPage.dart';
import 'package:loda_app/src/screens/transactionScreen/historyTransaction/historyTransactionPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportPage extends StatefulWidget {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final Map _walletSelected;
  const ReportPage({
    Key? key,
    required UserRepository userRepository,
    required CategoryRepository categoryRepository,
    required Map walletSelected,
  })  : _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        _walletSelected = walletSelected,
        super(key: key);
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  Map get _wallet => widget._walletSelected;
  List<ChartData>? chartData;
  TooltipBehavior? _tooltipBehavior;
  late Map _walletSelected = Map<String, dynamic>();
  DateTime _selectedStart = DateTime.now();
  DateTime _selectedEnd = DateTime.now();
  late List _categories = [];
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _walletSelected = _wallet;
    _selectedStart = DateTime(_selectedStart.year, _selectedStart.month, 1);
    _selectedEnd = DateTime(_selectedStart.year, _selectedStart.month, 31);
    getCategories();
    super.initState();
  }

  void getCategories() async {
    final data = await _userRepository.getCategories();
    data.docs.forEach((element) {
      Map _categori = element.data() as Map<String, dynamic>;
      _categori['id'] = element.id;
      _categories.add(_categori);
    });
  }

  Future openChangWallet() async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<QuerySnapshot>(
              future: _userRepository.getListWalletSnapshot(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    // final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    final List storedocs = [];
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map a = document.data() as Map<String, dynamic>;
                      storedocs.add(a);
                      a['id'] = document.id;
                    }).toList();
                    return OptionContainer(
                      padding: EdgeInsets.zero,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: storedocs.length,
                        itemBuilder: (context, index) {
                          return OptionContainer(
                            padding: EdgeInsets.zero,
                            // margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage(storedocs[index]['img']),
                                radius: 20.0,
                              ),
                              trailing: _walletSelected['name'] ==
                                      storedocs[index]['name']
                                  ? Icon(
                                      Icons.check_circle,
                                      color: AppStyle.blueColor,
                                    )
                                  : null,
                              title: Text(
                                storedocs[index]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              subtitle: Text(
                                "${storedocs[index]['remain']} ${storedocs[index]['currency']}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _walletSelected = storedocs[index];
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('no data');
                }
                return OptionContainer(
                    child: Center(child: CircularProgressIndicator()));
              },
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
    final size = MediaQuery.of(context).size.width;
    print(size);
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Report",
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 15),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                openChangWallet();
              },
              borderRadius: AppStyle.mainBorder,
              splashColor: AppStyle.blueColor,
              child: Container(
                height: 45.h,
                width: 45.w,
                decoration: BoxDecoration(
                  color: AppStyle.lightColor,
                  borderRadius: AppStyle.mainBorder,
                ),
                child: Center(
                  child: Image.asset(
                    _walletSelected['img'] ?? AppUI.logo,
                    width: 28.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
        AppBarBtn(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return HistoryTransactionPage(
                  userRepository: _userRepository,
                  categoryRepository: _categoryRepository,
                );
              }));
            },
            isAlign: false,
            icon: Icons.history),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder<DocumentSnapshot>(
                    future: _userRepository.getWalletById(
                      _walletSelected['id'],
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          Map<String, dynamic> a =
                              snapshot.data!.data() as Map<String, dynamic>;

                          a['id'] = snapshot.data!.id;

                          return OptionContainer(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 10),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Opening Balance",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          "${AppStyle.moneyFormat.format(a['balance'] ?? 0)} ${a['currency']}",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Container(
                                        height: 40,
                                        child: VerticalDivider(
                                            color: Colors.black)),
                                    Column(
                                      children: [
                                        Text(
                                          "Ending Balance",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          "${AppStyle.moneyFormat.format(a['remain'] ?? 0)} ${a['currency']}",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Net Income",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${AppStyle.moneyFormat.format((a['remain'] ?? 0) - (a['balance'] ?? 0))} ${a['currency']}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text('no data');
                      }
                      return Center(child: CircularProgressIndicator());
                    }),

                FutureBuilder<QuerySnapshot>(
                    future: _userRepository.getTransactionsByRange(
                        _walletSelected['id'],
                        DateTime(DateTime.now().year, DateTime.january, 1),
                        DateTime(DateTime.now().year, DateTime.december, 31)),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          num tonge1 = 0,
                              tongi1 = 0,
                              tonge2 = 0,
                              tongi2 = 0,
                              tonge3 = 0,
                              tongi3 = 0,
                              tonge4 = 0,
                              tongi4 = 0,
                              tonge5 = 0,
                              tongi5 = 0,
                              tonge6 = 0,
                              tongi6 = 0,
                              tonge7 = 0,
                              tongi7 = 0,
                              tonge8 = 0,
                              tongi8 = 0,
                              tonge9 = 0,
                              tongi9 = 0,
                              tonge10 = 0,
                              tongi10 = 0,
                              tonge11 = 0,
                              tongi11 = 0,
                              tonge12 = 0,
                              tongi12 = 0;
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map a = document.data() as Map<String, dynamic>;
                            DateTime temp =
                                (a['createAt'] as Timestamp).toDate();
                            switch (temp.month) {
                              case 1:
                                if (a['type'] == true) {
                                  tonge1 += a['money'];
                                } else {
                                  tongi1 += a['money'];
                                }
                                break;
                              case 2:
                                if (a['type'] == true) {
                                  tonge2 += a['money'];
                                } else {
                                  tongi2 += a['money'];
                                }
                                break;
                              case 3:
                                if (a['type'] == true) {
                                  tonge3 += a['money'];
                                } else {
                                  tongi3 += a['money'];
                                }
                                break;
                              case 4:
                                if (a['type'] == true) {
                                  tonge4 += a['money'];
                                } else {
                                  tongi4 += a['money'];
                                }
                                break;
                              case 5:
                                if (a['type'] == true) {
                                  tonge5 += a['money'];
                                } else {
                                  tongi5 += a['money'];
                                }
                                break;
                              case 6:
                                if (a['type'] == true) {
                                  tonge6 += a['money'];
                                } else {
                                  tongi6 += a['money'];
                                }
                                break;
                              case 7:
                                if (a['type'] == true) {
                                  tonge7 += a['money'];
                                } else {
                                  tongi7 += a['money'];
                                }
                                break;
                              case 8:
                                if (a['type'] == true) {
                                  tonge8 += a['money'];
                                } else {
                                  tongi8 += a['money'];
                                }
                                break;
                              case 9:
                                if (a['type'] == true) {
                                  tonge9 += a['money'];
                                } else {
                                  tongi9 += a['money'];
                                }
                                break;
                              case 10:
                                if (a['type'] == true) {
                                  tonge10 += a['money'];
                                } else {
                                  tongi10 += a['money'];
                                }
                                break;
                              case 11:
                                if (a['type'] == true) {
                                  tonge11 += a['money'];
                                } else {
                                  tongi11 += a['money'];
                                }
                                break;
                              case 12:
                                if (a['type'] == true) {
                                  tonge12 += a['money'];
                                } else {
                                  tongi12 += a['money'];
                                }
                                break;
                            }
                          }).toList();
                          chartData1.add(ChartData('Jan', tonge1, tongi1));
                          chartData1.add(ChartData('Feb', tonge2, tongi2));
                          chartData1.add(ChartData('Mar', tonge3, tongi3));
                          chartData1.add(ChartData('Apr', tonge4, tongi4));
                          chartData1.add(ChartData('May', tonge5, tongi5));
                          chartData1.add(ChartData('Jun', tonge6, tongi6));
                          chartData1.add(ChartData('Jul', tonge7, tongi7));
                          chartData1.add(ChartData('Aug', tonge8, tongi8));
                          chartData1.add(ChartData('Sep', tonge9, tongi9));
                          chartData1.add(ChartData('Oct', tonge10, tongi10));
                          chartData1.add(ChartData('Nov', tonge11, tongi11));
                          chartData1.add(ChartData('Dec', tonge12, tongi12));
                          return OptionContainer(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 10),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                series: <ChartSeries>[
                                  StackedColumnSeries<ChartData, String>(
                                      color: Color(0xffb57084),
                                      groupName: 'Group A',
                                      dataSource: chartData1,
                                      xValueMapper: (ChartData sales, _) =>
                                          sales.x,
                                      yValueMapper: (ChartData sales, _) =>
                                          sales.y1),
                                  StackedColumnSeries<ChartData, String>(
                                      color: Color(0xff69C5F6),
                                      groupName: 'Group B',
                                      dataSource: chartData1,
                                      xValueMapper: (ChartData sales, _) =>
                                          sales.x,
                                      yValueMapper: (ChartData sales, _) =>
                                          sales.y2),
                                ],
                              ));
                        }
                      } else if (snapshot.hasError) {
                        return Text('no data');
                      }
                      return Center(child: CircularProgressIndicator());
                    }),

                //chart expense
                FutureBuilder<QuerySnapshot>(
                  future: _userRepository.getTransactionsByTypeRange(
                      _walletSelected['id'],
                      true,
                      _selectedStart,
                      _selectedEnd),
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
                          if (a['type'] == true) {
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
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ReportDetailPage(
                                  userRepository: _userRepository,
                                  wid: _walletSelected['id'],
                                  categories: _categories,
                                  type: true,
                                );
                              }));
                            },
                            child: OptionContainer(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 20),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                      color: Color(0xffb57084),
                                    ),
                                  ),
                                  storedocs.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Image.asset(AppUI.Iextraincome),
                                        )
                                      : Container(
                                          child: SfCircularChart(
                                            borderWidth: 10,
                                            // borderColor: Colors.red,
                                            margin: EdgeInsets.zero,
                                            series: <CircularSeries>[
                                              DoughnutSeries<dynamic, String>(
                                                  dataSource: storedocs,
                                                  xValueMapper:
                                                      (dynamic data, _) =>
                                                          data['imgCategory'],
                                                  yValueMapper:
                                                      (dynamic data, _) =>
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
                                                                child: Image
                                                                    .asset(data[
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
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Text('no data');
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),

                //chart revenue
                FutureBuilder<QuerySnapshot>(
                  future: _userRepository.getTransactionsByTypeRange(
                      _walletSelected['id'],
                      false,
                      _selectedStart,
                      _selectedEnd),
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
                          if (a['type'] == false) {
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

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ReportDetailPage(
                                  userRepository: _userRepository,
                                  wid: _walletSelected['id'],
                                  categories: _categories,
                                  type: false,
                                );
                              }));
                            },
                            child: OptionContainer(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 20),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Revenues",
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
                                      color: Color(0xff69C5F6),
                                    ),
                                  ),
                                  storedocs.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:
                                              Image.asset(AppUI.Iextraincome),
                                        )
                                      : Container(
                                          child: SfCircularChart(
                                            borderWidth: 10,
                                            // borderColor: Colors.red,
                                            margin: EdgeInsets.zero,
                                            series: <CircularSeries>[
                                              DoughnutSeries<dynamic, String>(
                                                  dataSource: storedocs,
                                                  xValueMapper:
                                                      (dynamic data, _) =>
                                                          data['imgCategory'],
                                                  yValueMapper:
                                                      (dynamic data, _) =>
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
                                                                child: Image
                                                                    .asset(data[
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
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Text('no data');
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<ChartData> chartData1 = [];
}

class ChartData {
  ChartData(this.x, this.y1, this.y2);
  final String x;
  final num y1;
  final num y2;
}
