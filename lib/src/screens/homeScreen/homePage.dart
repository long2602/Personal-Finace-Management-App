import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loda_app/src/blocs/tab_bloc.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/events/tab_event.dart';
import 'package:loda_app/src/models/user.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/homeScreen/section.dart';
import 'package:loda_app/src/screens/transactionScreen/historyTransaction/historyTransactionPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final Users _user;
  final Map _walletSelected;
  HomePage({
    Key? key,
    required UserRepository userRepository,
    required CategoryRepository categoryRepository,
    required Users user,
    required Map walletSelected,
  })  : _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        _user = user,
        _walletSelected = walletSelected,
        super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  Users get _user => widget._user;
  Map get _wallet => widget._walletSelected;
  String dropdownValue = 'Today';
  late Map _walletSelected = _wallet;
  @override
  void initState() {
    print("init home");
    super.initState();
    _walletSelected = _wallet;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppStyle.mainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundImage: _user.img!.isNotEmpty
                                ? NetworkImage(_user.img!)
                                : AssetImage(AppUI.ava1) as ImageProvider,
                          ),
                          SizedBox(
                            width: 14.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello,",
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                AutoSizeText(
                                  _user.name,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppBarBtn(
                      onPressed: () async {
                        final r = await Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return HistoryTransactionPage(
                            userRepository: _userRepository,
                            categoryRepository: _categoryRepository,
                          );
                        }));
                        if (r != null) {
                          BlocProvider.of<TabBloc>(context)
                              .add(TabEventChangeHomeTab());
                        }
                      },
                      isAlign: false,
                      icon: Icons.history,
                    )
                  ],
                ),
              ),
              //Card ATM
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    openChangWallet();
                    print("tap");
                  },
                  child: FutureBuilder<QuerySnapshot>(
                    future: _userRepository.getSelectedWallet(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          late Map a;
                          // final List<DocumentSnapshot> documents = snapshot.data!.docs;
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            a = document.data() as Map<String, dynamic>;
                            a['id'] = document.id;
                          }).toList();
                          keepWallet(a);
                          _walletSelected = a;
                          return Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: AppStyle.blueColor,
                              borderRadius: AppStyle.mainBorder,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 25, 40, 25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Balance",
                                              style: TextStyle(
                                                  color: AppStyle.lighTextColor,
                                                  fontSize: 20),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: AutoSizeText(
                                                "${AppStyle.moneyFormat.format(_walletSelected['remain'] ?? 0)} ${_walletSelected['currency']}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 35.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Wallet Holder",
                                              style: TextStyle(
                                                  color: AppStyle.lighTextColor,
                                                  fontSize: 20.sp),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: AutoSizeText(
                                                _user.name.toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 25),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 255, 255, .25),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50.r),
                                          bottomLeft: Radius.circular(50.r),
                                        )),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FaIcon(
                                        FontAwesomeIcons.wallet,
                                        color: Colors.white,
                                        size: 50.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyle.mainBorder,
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  underline: Container(
                    height: 0,
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.chevronDown,
                    color: AppStyle.textColor,
                  ),
                  iconSize: 24.sp,
                  style: TextStyle(
                      color: AppStyle.textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Today',
                    'This week',
                    'This month',
                    'This quater',
                    'This year'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              OptionContainer(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 20),
                child: FutureBuilder<QuerySnapshot>(
                  future: choice(dropdownValue, _walletSelected['id']),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        num tongE = 0;
                        num tongR = 0;
                        final List storedocsE = [];
                        final List storedocsR = [];
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map a = document.data() as Map<String, dynamic>;
                          a['id'] = document.id;
                          if (a['type'] == true) {
                            tongE += a['money'];
                            storedocsE.add(a);
                          } else {
                            tongR += a['money'];
                            storedocsR.add(a);
                          }
                        }).toList();
                        List b = [];
                        b.add({
                          'title': 'Expense',
                          'value': tongE,
                          'color': Color(0xffb57084)
                        });
                        b.add({
                          'title': 'Income',
                          'value': tongR,
                          'color': Color(0xff5985b5),
                        });

                        return Row(
                          children: [
                            Expanded(
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: CategoryAxis(isVisible: false),
                                series: <ChartSeries>[
                                  ColumnSeries<dynamic, String>(
                                    dataSource: b,
                                    xValueMapper: (dynamic data, _) =>
                                        data['title'],
                                    yValueMapper: (dynamic data, _) =>
                                        data['value'],
                                    pointColorMapper: (dynamic data, _) =>
                                        data['color'],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: AutoSizeText(
                                      b[0]['title'],
                                      maxLines: 1,
                                    ),
                                    subtitle: AutoSizeText(
                                      '${AppStyle.moneyFormat.format(b[0]['value'] ?? 0)}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color:
                                              b[0]['color'] ?? Colors.red[300]),
                                    ),
                                  ),
                                  ListTile(
                                    title: AutoSizeText(b[1]['title']),
                                    subtitle: AutoSizeText(
                                      '${AppStyle.moneyFormat.format(b[1]['value'] ?? 0)}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: b[1]['color'] ??
                                              Colors.green[300]),
                                    ),
                                  ),
                                  Divider(),
                                  Center(
                                    child: AutoSizeText(
                                      '${AppStyle.moneyFormat.format((b[1]['value'] ?? 0) - (b[0]['value'] ?? 0))}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
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
            ],
          ),
        ),
      ),
    );
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
                                  // keepWallet(_walletSelected);
                                  _userRepository
                                      .selectMainWallet(_walletSelected['id']);
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

  Future<QuerySnapshot> choice(String selected, String wid) async {
    DateTime _selectedStart = DateTime.now();
    DateTime _selectedEnd = DateTime.now();
    if (selected == 'Today') {
      return _userRepository.getTransactionsByDate(wid, DateTime.now());
    } else {
      if (selected == 'This week') {
        _selectedStart =
            DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
        _selectedEnd = DateTime.now()
            .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));
      } else if (selected == 'This month') {
        _selectedStart = DateTime(_selectedStart.year, _selectedStart.month, 1);
        _selectedEnd = DateTime(_selectedStart.year, _selectedStart.month, 31);
      } else if (selected == 'This quater') {
        if (_selectedStart.month < 4) {
          _selectedStart = DateTime(DateTime.now().year, 1, 1);
          _selectedEnd = DateTime(DateTime.now().year, 3, 31);
        } else if (_selectedStart.month >= 4 && _selectedStart.month < 7) {
          _selectedStart = DateTime(DateTime.now().year, 4, 1);
          _selectedEnd = DateTime(DateTime.now().year, 6, 30);
        } else if (_selectedStart.month >= 7 && _selectedStart.month < 10) {
          _selectedStart = DateTime(DateTime.now().year, 7, 1);
          _selectedEnd = DateTime(DateTime.now().year, 9, 30);
        } else {
          _selectedStart = DateTime(DateTime.now().year, 10, 1);
          _selectedEnd = DateTime(DateTime.now().year, 12, 31);
        }
      } else if (selected == 'This year') {
        _selectedStart = DateTime(_selectedStart.year, 1, 1);
        _selectedEnd = DateTime(_selectedStart.year, 12, 31);
      }
    }
    return _userRepository.getTransactionsByRange(
        wid, _selectedStart, _selectedEnd);
  }
}
