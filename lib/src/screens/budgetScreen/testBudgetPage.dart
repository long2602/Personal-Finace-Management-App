import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/budgetScreen/detailBudgetPage.dart';
import 'package:loda_app/src/screens/budgetScreen/viewBudgetPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';

class TestBudget extends StatefulWidget {
  final Map _budget;
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;

  const TestBudget({
    Key? key,
    required UserRepository userRepository,
    required Map budget,
    required CategoryRepository categoryRepository,
  })  : _budget = budget,
        _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        super(key: key);

  @override
  _TestBudgetState createState() => _TestBudgetState();
}

class _TestBudgetState extends State<TestBudget> {
  Map get _budget => widget._budget;
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  late List _categories = [];
  _getDate(DateTime _selectedDate) {
    return DateFormat.yMd().format(_selectedDate);
  }

  _getDayLeft(Timestamp end) {
    DateTime e = end.toDate();
    return e.day - DateTime.now().day;
  }

  _getNumDay(Timestamp start) {
    DateTime e = start.toDate();
    return DateTime.now().day - e.day;
  }

  @override
  void initState() {
    super.initState();
    getWallet();
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
  Widget build(BuildContext context) {
    DateTime _start = (_budget['startDay'] as Timestamp).toDate();
    DateTime _end = (_budget['endDay'] as Timestamp).toDate();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Budget",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        AppBarBtn(
            onPressed: () async {
              final test = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewBudgetPage(
                      userRepository: _userRepository,
                      categoryRepository: _categoryRepository,
                      budget: _budget)));
              if (test != null) {
                setState(() {});
              }
            },
            isAlign: false,
            icon: Icons.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
        child: FutureBuilder(
            future: _userRepository.getListBudgetById(_budget['id']),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // List result = snapshot.data as List;
                  // final data1 = result[0] as QuerySnapshot;
                  // final data2 = result[1] as DocumentSnapshot;
                  // final List storedocs = [];
                  // data1.docs.map((DocumentSnapshot document) {
                  //   Map a = document.data() as Map<String, dynamic>;
                  //   if (a['idCategory'] == _budget['idCategory']) {
                  //     storedocs.add(a);
                  //     a['id'] = document.id;
                  //     _categories.forEach((element) {
                  //       if (element['id'] == a['idCategory']) {
                  //         a['imgCategory'] = element['img'];
                  //         a['nameCategory'] = element['name'];
                  //       }
                  //     });
                  //   }
                  // }).toList();
                  // data2.data() as Map<String, dynamic>;
                  final a = snapshot.data as DocumentSnapshot;
                  final budget = a.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      OptionContainer(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            Text(
                              '${AppStyle.moneyFormat.format(budget['balance'])} ${budget['currency']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.sp),
                            ),
                          ],
                        ),
                      ),
                      OptionContainer(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  "${_getDate((budget['startDay'] as Timestamp).toDate())} - ${_getDate((budget['endDay'] as Timestamp).toDate())}",
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  '${AppStyle.moneyFormat.format(budget['balance'])} ${budget['currency']}',
                                  style: TextStyle(fontSize: 18.sp),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: LinearProgressIndicator(
                                value: budget['remain'] / budget['balance'],
                                color: AppStyle.blueColor,
                                minHeight: 14,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  "${_getDayLeft(budget['endDay'])} days left",
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  '${AppStyle.moneyFormat.format(budget['balance'] - budget['remain'])} ${budget['currency']}',
                                  style: TextStyle(fontSize: 18.sp),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: budget['remain'] == 0 ? false : true,
                        child: OptionContainer(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            title: Text("Detail"),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailBudgetPage(
                                        userRepository: _userRepository,
                                        categoryRepository: _categoryRepository,
                                        budget: _budget,
                                      )));
                            },
                          ),
                        ),
                      ),
                      OptionContainer(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    AutoSizeText(
                                      "Actual expense",
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      '${AppStyle.moneyFormat.format((budget['remain']) / (_getNumDay(budget['startDay']) + 1))} ${budget['currency']} /day',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  children: [
                                    AutoSizeText(
                                      "Recommend spend",
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      '${AppStyle.moneyFormat.format((budget['balance'] - budget['remain']) / _getDayLeft(budget['endDay']))} ${budget['currency']} /day',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            Divider(),
                            Column(
                              children: [
                                AutoSizeText(
                                  "Expense plan",
                                  maxLines: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    '${AppStyle.moneyFormat.format(budget['remain'] + (_getDayLeft(budget['endDay']) * (budget['remain']) / (1 + _getNumDay(budget['startDay']))))} ${budget['currency']} /day',
                                    maxLines: 1,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
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
            }),
      ),
    );
  }
}
