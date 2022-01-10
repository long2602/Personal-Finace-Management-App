import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/searchScreen/searchPage.dart';
import 'package:loda_app/src/screens/transactionScreen/historyTransaction/dataSettingPage.dart';
import 'package:loda_app/src/screens/transactionScreen/viewTransaction/viewTransactionPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryTransactionPage extends StatefulWidget {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  const HistoryTransactionPage(
      {Key? key,
      required UserRepository userRepository,
      required CategoryRepository categoryRepository})
      : _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        super(key: key);
  @override
  _HistoryTransactionPageState createState() => _HistoryTransactionPageState();
}

class _HistoryTransactionPageState extends State<HistoryTransactionPage> {
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  String _selected = "This month";
  String? customeSelected;
  late Map _walletSelected = Map<String, dynamic>();

  DateTime _selectedStart = DateTime.now();
  DateTime _selectedEnd = DateTime.now();

  late List _categories = [];
  @override
  void initState() {
    super.initState();
    getWallet();
  }

  void getWallet() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final results = await Future.wait(
        [SharedPreferences.getInstance(), _userRepository.getCategories()]);
    SharedPreferences prefs = results[0] as SharedPreferences;
    String? userPref = prefs.getString('WALLET');
    Map<String, dynamic> userMap =
        jsonDecode(userPref!) as Map<String, dynamic>;
    final data = results[1] as QuerySnapshot;
    data.docs.forEach((element) {
      Map _categori = element.data() as Map<String, dynamic>;
      _categori['id'] = element.id;
      _categories.add(_categori);
    });
    setState(() {
      _walletSelected = userMap;
    });
  }

  Future _selectOption(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppStyle.lightColor,
                borderRadius: AppStyle.mainBorder,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Search Transaction"),
                    leading: Icon(Icons.search),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage(
                                    userRepository: _userRepository,
                                    walletSelected: _walletSelected,
                                    categoryRepository: _categoryRepository,
                                    categories: _categories,
                                  )));
                    },
                  ),
                  ListTile(
                    title: Text("Change Wallet"),
                    leading: Icon(Icons.account_balance_wallet),
                    onTap: () {
                      openChangWallet();
                    },
                  ),
                ],
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

  Future openChangWallet() {
    return showDialog(
        context: context,
        builder: (BuildContext context1) {
          return AlertDialog(
            content: FutureBuilder<QuerySnapshot>(
              future: _userRepository.getListWalletSnapshot(),
              builder: (context1, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    );
                  } else {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    final List storedocs = [];
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map a = document.data() as Map<String, dynamic>;
                      storedocs.add(a);
                      a['id'] = document.id;
                    }).toList();
                    return Container(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: storedocs.length,
                            itemBuilder: (context1, index) {
                              return OptionContainer(
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.symmetric(vertical: 4),
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
                                      Navigator.pop(context1);
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('no data');
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  _getDate(DateTime _selectedDate) {
    return DateFormat.yMMMEd().format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "History",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context, true);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        AppBarBtn(
            onPressed: () => _selectOption(context),
            isAlign: false,
            icon: Icons.more_vert),
      ),
      body: Column(
        children: [
          OptionContainer(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            margin: EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
            child: InkWell(
              onTap: () async {
                final choice = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return DataSettingPage();
                }));
                if (choice != null) {
                  if (choice['title'] == 'Yesterday' ||
                      choice['title'] == "Today")
                    setState(() {
                      _selected = choice['title'];
                      _selectedStart = choice['date'];
                    });
                  else if (choice['title'] == 'Select day') {
                    setState(() {
                      _selected = _getDate(choice['date']);
                      _selectedStart = choice['date'];
                      customeSelected = choice['title'];
                    });
                  } else if (choice['title'] == 'This week' ||
                      choice['title'] == "Last week") {
                    setState(() {
                      _selected = choice['title'];
                      _selectedStart = choice['dateS'];
                      _selectedEnd = choice['dateE'];
                    });
                  } else if (choice['title'] == 'This month' ||
                      choice['title'] == "Last month") {
                    setState(() {
                      _selected = choice['title'];
                      _selectedStart =
                          DateTime(DateTime.now().year, choice['date'], 1);
                      _selectedEnd =
                          DateTime(DateTime.now().year, choice['date'], 31);
                    });
                  } else if (choice['title'] == 'Select month') {
                    setState(() {
                      switch (choice['date']) {
                        case 1:
                          _selected = 'January';
                          break;
                        case 2:
                          _selected = 'February';
                          break;
                        case 3:
                          _selected = 'March';
                          break;
                        case 4:
                          _selected = 'April';
                          break;
                        case 5:
                          _selected = 'May';
                          break;
                        case 6:
                          _selected = 'June';
                          break;
                        case 7:
                          _selected = 'July';
                          break;
                        case 8:
                          _selected = 'August';
                          break;
                        case 9:
                          _selected = 'September';
                          break;
                        case 10:
                          _selected = 'October';
                          break;
                        case 11:
                          _selected = 'November';
                          break;
                        case 12:
                          _selected = 'December';
                          break;
                      }
                      _selectedStart =
                          DateTime(DateTime.now().year, choice['date'], 1);
                      _selectedEnd =
                          DateTime(DateTime.now().year, choice['date'], 31);
                    });
                  } else if (choice['title'] == 'Quarter') {
                    setState(() {
                      _selected = choice['date'];
                      if (_selected == "Quarter I") {
                        _selectedStart = DateTime(DateTime.now().year, 1, 1);
                        _selectedEnd = DateTime(DateTime.now().year, 3, 31);
                      } else if (_selected == "Quarter II") {
                        _selectedStart = DateTime(DateTime.now().year, 4, 1);
                        _selectedEnd = DateTime(DateTime.now().year, 6, 30);
                      } else if (_selected == "Quarter III") {
                        _selectedStart = DateTime(DateTime.now().year, 7, 1);
                        _selectedEnd = DateTime(DateTime.now().year, 9, 30);
                      } else {
                        _selectedStart = DateTime(DateTime.now().year, 10, 1);
                        _selectedEnd = DateTime(DateTime.now().year, 12, 31);
                      }
                    });
                  } else if (choice['title'] == 'Custom') {
                    setState(() {
                      _selected =
                          "${_getDate(choice['dateS'])} - ${_getDate(choice['dateE'])}";
                      _selectedStart = choice['dateS'];
                      _selectedEnd = choice['dateE'];
                    });
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.navigate_before),
                  AutoSizeText(
                    _selected,
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.navigate_next)
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
                future: choice(_selected, _walletSelected['id'] ?? "1"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      // final List<DocumentSnapshot> documents = snapshot.data!.docs;
                      final List storedocs = [];
                      snapshot.data!.docs
                          .map((DocumentSnapshot document) async {
                        Map a = document.data() as Map<String, dynamic>;
                        a['id'] = document.id;
                        _categories.forEach((element) {
                          if (element['id'] == a['idCategory']) {
                            a['imgCategory'] = element['img'];
                            a['nameCategory'] = element['name'];
                          }
                        });

                        storedocs.add(a);
                      }).toList();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppStyle.mainPadding),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OptionContainer(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 16.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Image.asset(AppUI.history2x),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 18),
                                        child: AutoSizeText(
                                          "Manage your transactions\nhistory more efficiently",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                storedocs.isEmpty
                                    ? Center(
                                        child: Text("Don't have transaction"))
                                    : GroupedListView<dynamic, String>(
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
                                              (element['createAt'] as Timestamp)
                                                  .toDate();
                                          final d12 = DateFormat.yMMMMEEEEd()
                                              .format(dt);
                                          return d12;
                                        },
                                        groupSeparatorBuilder: (String value) {
                                          List paths = value.split(',');
                                          List paths2 =
                                              paths[1].toString().split(' ');
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
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(paths[0]),
                                                      Text(
                                                          '${paths2[1]} ${paths[2]}'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        itemBuilder:
                                            (context, dynamic element) {
                                          return Slidable(
                                            child: OptionContainer(
                                              margin: EdgeInsets.only(
                                                  bottom: 4.0, top: 4.0),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: ListTile(
                                                onTap: () async {
                                                  final value =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                    return ViewTransactionPage(
                                                      transaction: element,
                                                      userRepository:
                                                          _userRepository,
                                                      wallet: _walletSelected,
                                                      categoryRepository:
                                                          _categoryRepository,
                                                    );
                                                  }));
                                                  setState(() {});
                                                },
                                                leading: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      element['imgCategory']),
                                                  radius: 20.0,
                                                ),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      element['nameCategory'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${AppStyle.moneyFormat.format(element['money'])} ${element['currency']}',
                                                      style: TextStyle(
                                                        fontSize: 15.0.sp,
                                                        color: element[
                                                                    'type'] ==
                                                                true
                                                            ? Color(0xffb57084)
                                                            : Color(0xff5985b5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actionPane:
                                                SlidableDrawerActionPane(),
                                            secondaryActions: [
                                              IconSlideAction(
                                                onTap: () => _deleteDialog(
                                                    context, element),
                                                color: Color(0xfff1f4f8),
                                                iconWidget: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      12, 4, 0, 4),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: AppStyle
                                                            .mainBorder),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color:
                                                          AppStyle.lightColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                        // optional
                                        ),
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
                }),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDialog(BuildContext context, Map element) async {
    await showDialog(
      context: context,
      builder: (BuildContext context1) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppUI.walletWarning2x,
                width: 100.w,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 22),
                child: Text(
                  "Deleted data cannot be recovered. Do you want to continue?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: AppStyle.mainBorder,
                        child: MaterialButton(
                          minWidth: double.infinity,
                          color: AppStyle.backgroundColor,
                          elevation: 0,
                          onPressed: () => Navigator.pop(context1),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppStyle.hintTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius: AppStyle.mainBorder,
                        child: MaterialButton(
                          minWidth: double.infinity,
                          color: AppStyle.blueColor,
                          elevation: 0,
                          onPressed: () {
                            if (element['type'] == true) {
                              _userRepository.deleteTransaction(
                                  _walletSelected['id'], element['id']);
                              final newRemain =
                                  _walletSelected['remain'] + element['money'];
                              _userRepository.calculateWallet(
                                  newRemain, _walletSelected['id']);
                              _walletSelected['remain'] = newRemain;
                              _userRepository.remainBudget(
                                  element['idCategory'],
                                  element['money'].toString(),
                                  (element['createAt'] as Timestamp).toDate(),
                                  false);
                            } else {
                              _userRepository.deleteTransaction(
                                  _walletSelected['id'], element['id']);
                              final newRemain =
                                  _walletSelected['remain'] - element['money'];
                              _walletSelected['remain'] = newRemain;
                              _userRepository.calculateWallet(
                                  newRemain, _walletSelected['id']);
                            }

                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppStyle.lightColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: AppStyle.mainBorder),
      ),
      barrierDismissible: false,
    );
  }

  Future<QuerySnapshot> choice(String selected, String wid) async {
    if (selected == 'This month') {
      _selectedStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
      _selectedEnd = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day);
      return _userRepository.getTransactionsByRange(
          wid, _selectedStart, _selectedEnd);
    } else if (selected == 'Yesterday' ||
        selected == "Today" ||
        customeSelected == 'Select day') {
      customeSelected = null;
      return _userRepository.getTransactionsByDate(wid, _selectedStart);
    }
    return _userRepository.getTransactionsByRange(
        wid, _selectedStart, _selectedEnd);
  }
}
