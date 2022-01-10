import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/categoryScreen/categoryPage.dart';
import 'package:loda_app/src/screens/searchScreen/amountSearchPage.dart';
import 'package:loda_app/src/screens/searchScreen/searchResultPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionSearchPage extends StatefulWidget {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final List _categories;
  const OptionSearchPage(
      {Key? key,
      required UserRepository userRepository,
      required CategoryRepository categoryRepository,
      required List categories})
      : _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        _categories = categories,
        super(key: key);

  @override
  _OptionSearchPageState createState() => _OptionSearchPageState();
}

class _OptionSearchPageState extends State<OptionSearchPage> {
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  List get _categories => widget._categories;

  late Map _walletSelected = Map<String, dynamic>();
  Map? _catrgory = null;
  String _amountSelected = "All";
  String _categorySelected = "All";
  String _dateSelected = "All";
  num _so = 0;
  num _so2 = 0;
  DateTime _selectedStart = DateTime.now();
  DateTime _selectedEnd = DateTime.now();
  DateTimeRange? dateRange;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    getWallet();
  }

  void getWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('WALLET');
    Map<String, dynamic> userMap =
        jsonDecode(userPref!) as Map<String, dynamic>;
    setState(() {
      _walletSelected = userMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Search",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        AppBarBtn(
            onPressed: () {
              filterTransaction();
            },
            isAlign: false,
            icon: Icons.done),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
          child: OptionContainer(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  onTap: () {
                    _selectOptionWallet(context);
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Wallet",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppStyle.hintTextColor),
                      ),
                      Text(_walletSelected['name'] ?? ""),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    _selectOptionMoney(context);
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppStyle.hintTextColor),
                      ),
                      Text(_amountSelected),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    _selectOptionCategory(context);
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppStyle.hintTextColor),
                      ),
                      Text(_categorySelected),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    _selectOptionDate(context);
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppStyle.hintTextColor),
                      ),
                      Text(_dateSelected),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getDate(DateTime _selectedDate) {
    return DateFormat.yMd().format(_selectedDate);
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 23)),
    );

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyle.blueColor, // header background color
              onPrimary: AppStyle.lighTextColor, // header text color
              onSurface: AppStyle.textColor, // body text color
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(),
              bodyText2: TextStyle(),
            ).apply(
              bodyColor: AppStyle.textColor,
              displayColor: AppStyle.blueColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
      _selectedStart = dateRange!.start;
      _selectedStart = dateRange!.end;
      _dateSelected = "${_getDate(_selectedStart)} - ${_getDate(_selectedEnd)}";
    });
  }

  Future<Null> _selectDate(BuildContext context, String title) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStart,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyle.blueColor, // header background color
              onPrimary: AppStyle.lighTextColor, // header text color
              onSurface: AppStyle.textColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  primary: Colors.red,
                  textStyle: TextStyle(fontSize: 14.sp) // button text color
                  ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedStart)
      setState(() {
        _selectedStart = picked;
        _dateSelected = "$title ${_getDate(_selectedStart)}";
      });
  }

  Future _selectOptionWallet(BuildContext context) async {
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

  Future _selectOptionMoney(BuildContext context) async {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("All"),
                    onTap: () {
                      setState(() {
                        _amountSelected = "All";
                      });
                      Navigator.pop(context1);
                    },
                  ),
                  ListTile(
                    title: Text("Under"),
                    onTap: () async {
                      final so = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => amountSearchPage(
                                    isBetween: false,
                                  )));
                      if (so != null) {
                        setState(() {
                          _so = num.parse(so.toString());
                          _amountSelected = "Under ${so.toString()}";
                        });
                      } else {
                        setState(() {
                          _amountSelected = "All";
                        });
                      }

                      Navigator.pop(context1);
                    },
                  ),
                  ListTile(
                    title: Text("Over"),
                    onTap: () async {
                      final so = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => amountSearchPage(
                                    isBetween: false,
                                  )));
                      if (so != null) {
                        setState(() {
                          _so = num.parse(so.toString());
                          _amountSelected = "Over ${so.toString()}";
                        });
                      } else {
                        setState(() {
                          _amountSelected = "All";
                        });
                      }

                      Navigator.pop(context1);
                    },
                  ),
                  ListTile(
                    title: Text("Between"),
                    onTap: () async {
                      final kq = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => amountSearchPage(
                                    isBetween: true,
                                  )));
                      if (kq != null) {
                        _so = num.parse(kq[0]);
                        _so2 = num.parse(kq[1]);
                        setState(() {
                          _amountSelected =
                              "${AppStyle.moneyFormat.format(_so)} ~ ${AppStyle.moneyFormat.format(_so2)}";
                        });
                      } else {
                        setState(() {
                          _amountSelected = "All";
                        });
                      }
                      Navigator.pop(context1);
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

  Future _selectOptionCategory(BuildContext context) async {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("All"),
                    onTap: () {
                      setState(() {
                        _categorySelected = "All";
                      });
                      Navigator.pop(context1);
                    },
                  ),
                  ListTile(
                    title: Text("All Expense"),
                    onTap: () {
                      setState(() {
                        _categorySelected = "All Expense";
                      });
                      Navigator.pop(context1);
                    },
                  ),
                  ListTile(
                    title: Text("All Income"),
                    onTap: () {
                      setState(() {
                        _categorySelected = "All Income";
                      });
                      Navigator.pop(context1);
                    },
                  ),
                  ListTile(
                    title: Text("Custom Category"),
                    onTap: () async {
                      _catrgory = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CategoryPage(
                          categoryRepository: _categoryRepository,
                          userRepository: _userRepository,
                        );
                      }));
                      if (_catrgory != null) {
                        setState(() {
                          _categorySelected = _catrgory!['name'];
                        });
                      } else {
                        setState(() {
                          _categorySelected = "All";
                        });
                      }
                      Navigator.pop(context1);
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

  Future _selectOptionDate(BuildContext context) async {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("All"),
                    onTap: () {
                      setState(() {
                        _dateSelected = "All";
                      });
                      Navigator.pop(context1);
                    },
                  ),
                  ListTile(
                    title: Text("Before"),
                    onTap: () {
                      Navigator.pop(context1);
                      _selectDate(context, 'Before');
                    },
                  ),
                  ListTile(
                    title: Text("After"),
                    onTap: () {
                      Navigator.pop(context1);
                      _selectDate(context, 'After');
                    },
                  ),
                  ListTile(
                    title: Text("Between"),
                    onTap: () {
                      Navigator.pop(context1);
                      pickDateRange(context);
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

  searchResultsList() {
    var showResults = [];
    if (_amountSelected != "All") {
      if (_amountSelected.contains("Under")) {
        for (var tripSnapshot in _allResults) {
          if (tripSnapshot['money'] < _so) {
            showResults.add(tripSnapshot);
          }
        }
      } else if (_amountSelected.contains("Over")) {
        for (var tripSnapshot in _allResults) {
          if (tripSnapshot['money'] > _so) {
            showResults.add(tripSnapshot);
          }
        }
      } else {
        for (var tripSnapshot in _allResults) {
          if (tripSnapshot['money'] < _so2 && tripSnapshot['money'] > _so) {
            showResults.add(tripSnapshot);
          }
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  searchResultCategory() {
    var showResults = [];
    if (_categorySelected != "All") {
      if (_categorySelected == "All Expense") {
        for (var tripSnapshot in _allResults) {
          if (tripSnapshot['type'] == true) {
            showResults.add(tripSnapshot);
          }
        }
      } else if (_categorySelected == "All Income") {
        for (var tripSnapshot in _allResults) {
          if (tripSnapshot['type'] == false) {
            showResults.add(tripSnapshot);
          }
        }
      } else {
        for (var tripSnapshot in _allResults) {
          if (tripSnapshot['idCategory'].toString() == _catrgory!['id']) {
            showResults.add(tripSnapshot);
          }
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    _allResults = showResults;
  }

  void filterTransaction() async {
    var data;
    if (_dateSelected.contains("After")) {
      data = await _userRepository.getTransactionsAfterDate(
          _walletSelected['id'], _selectedStart);
    } else if (_dateSelected.contains("Before")) {
      data = await _userRepository.getTransactionsBeforeDate(
          _walletSelected['id'], _selectedStart);
    } else if (_dateSelected == "All") {
      data = await _userRepository.getTransactions(_walletSelected['id']);
    } else {
      data = await _userRepository.getTransactionsByRange(
          _walletSelected['id'], _selectedStart, _selectedEnd);
    }

    _allResults = data.docs;

    searchResultCategory();
    searchResultsList();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchResultPage(
                  result: _resultsList,
                  userRepository: _userRepository,
                  categoryRepository: _categoryRepository,
                  walletSelected: _walletSelected,
                  categories: _categories,
                )));
  }
}
