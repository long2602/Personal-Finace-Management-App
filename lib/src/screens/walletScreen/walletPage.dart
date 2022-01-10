import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/models/user.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/budgetScreen/testBudgetPage.dart';
import 'package:loda_app/src/screens/transactionScreen/historyTransaction/historyTransactionPage.dart';
import 'package:loda_app/src/screens/walletScreen/tab/budgetTab.dart';
import 'package:loda_app/src/screens/walletScreen/tab/walletTab.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/itemWallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletPage extends StatefulWidget {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final Map _walletSelected;
  final Users _user;
  const WalletPage({
    Key? key,
    required UserRepository userRepository,
    required Users user,
    required CategoryRepository categoryRepository,
    required Map walletSelected,
  })  : _userRepository = userRepository,
        _user = user,
        _categoryRepository = categoryRepository,
        _walletSelected = walletSelected,
        super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  @override
  late TabController _tabController;
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  Map get _wallet => widget._walletSelected;
  Users get _user => widget._user;
  final TextEditingController _searchController = TextEditingController();
  bool isSearch = false;
  late Map _walletSelected = Map<String, dynamic>();
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  late Future resultsBudgetLoaded;
  List _allBudgetResults = [];
  List _resultsBudgetList = [];
  late List _categories = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _walletSelected = _wallet;
    getWallet();
    print("init wallet");
  }

  void getWallet() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final results = await Future.wait([_userRepository.getCategories()]);
    final data = results[0] as QuerySnapshot;
    data.docs.forEach((element) {
      Map _categori = element.data() as Map<String, dynamic>;
      _categori['id'] = element.id;
      _categories.add(_categori);
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];
    var showResults1 = [];
    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var title = tripSnapshot['name'].toString().toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
      for (var budget in _allBudgetResults) {
        var title = budget['name'].toString().toLowerCase();
        var id = budget['idCategory'].toString();
        var categorititle;
        _categories.forEach((element) {
          if (id == element['id']) {
            categorititle = element['name'].toString().toLowerCase();
            return;
          }
        });
        if (title.contains(_searchController.text.toLowerCase()) ||
            categorititle.contains(_searchController.text.toLowerCase())) {
          showResults1.add(budget);
        }
      }
    } else {
      showResults = List.from(_allResults);
      showResults1 = List.from(_allBudgetResults);
    }
    setState(() {
      _resultsList = showResults;
      _resultsBudgetList = showResults1;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    var data = await _userRepository.getListWalletSnapshot();
    var data1 = await _userRepository.getListBudget(_walletSelected['id']);
    setState(() {
      _allResults = data.docs;
      _allBudgetResults = data1.docs;
    });
    searchResultsList();
    return "complete";
  }

  _getDate(DateTime _selectedDate) {
    return DateFormat.yMd().format(_selectedDate);
  }

  _getDayLeft(Timestamp end) {
    DateTime e = end.toDate();
    return e.day - DateTime.now().day;
  }

  @override
  Widget build(BuildContext context) {
    print("build wallet");
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: isSearch == false
          ? AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 70,
              backgroundColor: AppStyle.backgroundColor,
              title: Container(
                width: double.infinity,
                // height: 60,
                decoration: BoxDecoration(color: AppStyle.backgroundColor),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 15),
                      child: Container(
                        height: 45.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: AppStyle.lightColor,
                          borderRadius: AppStyle.mainBorder,
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              resultsLoaded =
                                  getUsersPastTripsStreamSnapshots();
                              setState(() {
                                isSearch = true;
                              });
                            },
                            icon: Icon(
                              Icons.search,
                              color: AppStyle.blueColor,
                              size: 28.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "Wallet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppStyle.textColor,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 4),
                      child: Container(
                        height: 45.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: AppStyle.lightColor,
                          borderRadius: AppStyle.mainBorder,
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return HistoryTransactionPage(
                                  userRepository: _userRepository,
                                  categoryRepository: _categoryRepository,
                                );
                              }));
                            },
                            icon: Icon(
                              Icons.history,
                              color: AppStyle.blueColor,
                              size: 28.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                  color: AppStyle.lightColor,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                labelColor: AppStyle.textColor,
                tabs: [
                  Tab(
                    child: Align(
                      child: Text(
                        "Wallet",
                        style: TextStyle(fontSize: 16),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  Tab(
                    child: Align(
                      child: Text(
                        "Budget",
                        style: TextStyle(fontSize: 16),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 70,
              backgroundColor: AppStyle.backgroundColor,
              title: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        autocorrect: false,
                        decoration: InputDecoration(
                          fillColor: AppStyle.lightColor,
                          filled: true,
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: Container(
                            width: 50.sp,
                            child: Icon(
                              Icons.search,
                              color: AppStyle.textColor,
                            ),
                          ),
                          hintText: "Enter ....",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffCED0D2)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffEEEEEE), width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: AppStyle.hintTextColor),
                      ),
                      onPressed: () {
                        setState(() {
                          isSearch = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
      body: isSearch == false
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppStyle.mainPadding),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    //wallet
                    WalletTab(
                      userRepository: _userRepository,
                    ),

                    //budget
                    BudgetTab(
                      userRepository: _userRepository,
                      categoryRepository: _categoryRepository,
                      walletSelected: _walletSelected,
                    ),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppStyle.mainPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText("Wallet Result"),
                    ),
                    Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _resultsList.length,
                      itemBuilder: (context, index) {
                        Map a =
                            _resultsList[index].data() as Map<String, dynamic>;
                        return itemWallets(a, _userRepository, context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText("Budget Result"),
                    ),
                    Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _resultsBudgetList.length,
                      itemBuilder: (context, index) {
                        Map storedocs = _resultsBudgetList[index].data()
                            as Map<String, dynamic>;
                        storedocs['id'] = _resultsBudgetList[index].id;
                        storedocs['nameWallet'] = _wallet['name'];
                        storedocs['imgWallet'] = _wallet['img'];
                        _categories.forEach((element) {
                          if (element['id'] == storedocs['idCategory']) {
                            storedocs['imgCategory'] = element['img'];
                            storedocs['nameCategory'] = element['name'];
                          }
                        });
                        return OptionContainer(
                          margin: EdgeInsets.only(bottom: 6.0, top: 6.0),
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return TestBudget(
                                  userRepository: _userRepository,
                                  budget: storedocs,
                                  categoryRepository: _categoryRepository,
                                );
                              }));
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage(storedocs['imgCategory']),
                              radius: 20.0,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      storedocs['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    AutoSizeText(
                                      "${_getDate((storedocs['startDay'] as Timestamp).toDate())} - ${_getDate((storedocs['endDay'] as Timestamp).toDate())}",
                                    ),
                                  ],
                                ),
                                Text(
                                  "${AppStyle.moneyFormat.format(storedocs['balance'] ?? 0)} VNĐ",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: LinearProgressIndicator(
                                    value: storedocs['remain'] /
                                        storedocs['balance'],
                                    color: AppStyle.blueColor,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(
                                      "${_getDayLeft(storedocs['endDay'])} days left",
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      '${AppStyle.moneyFormat.format(storedocs['balance'] - storedocs['remain'])} ${storedocs['currency']}',
                                      style: TextStyle(fontSize: 12.sp),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
