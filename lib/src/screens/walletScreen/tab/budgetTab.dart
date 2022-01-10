import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/addBudgetScreen/addBudgetPage.dart';
import 'package:loda_app/src/screens/budgetScreen/testBudgetPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';

class BudgetTab extends StatefulWidget {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final Map _walletSelected;
  const BudgetTab({
    Key? key,
    required UserRepository userRepository,
    required CategoryRepository categoryRepository,
    required Map walletSelected,
  })  : _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        _walletSelected = walletSelected,
        super(key: key);

  @override
  _BudgetTabState createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  Map get _wallet => widget._walletSelected;
  late List _categories = [];

  _getDate(DateTime _selectedDate) {
    return DateFormat.yMd().format(_selectedDate);
  }

  _getDayLeft(Timestamp end) {
    DateTime e = end.toDate();
    return e.day - DateTime.now().day;
  }

  @override
  void initState() {
    super.initState();
    getWallet();
  }

  _getPercent(num num1, num num2) {
    return num2 / num1;
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
    return FutureBuilder<QuerySnapshot>(
      future: _userRepository.getListBudget(_userRepository.users.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            final List storedocs = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              a['nameWallet'] = _wallet['name'];
              a['imgWallet'] = _wallet['img'];
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.asset(AppUI.budget2x),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18),
                            child: AutoSizeText(
                              "Add budgets help you\nBetter manage your spending",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: storedocs.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Slidable(
                          child: OptionContainer(
                            margin: EdgeInsets.only(bottom: 6.0, top: 6.0),
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return TestBudget(
                                    userRepository: _userRepository,
                                    budget: storedocs[index],
                                    categoryRepository: _categoryRepository,
                                  );
                                }));
                              },
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(storedocs[index]
                                        ['imgCategory'] ??
                                    AppUI.logo),
                                radius: 20.0,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        storedocs[index]['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      AutoSizeText(
                                        "${_getDate((storedocs[index]['startDay'] as Timestamp).toDate())} - ${_getDate((storedocs[index]['endDay'] as Timestamp).toDate())}",
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${AppStyle.moneyFormat.format(storedocs[index]['balance'] ?? 0)} VNĐ",
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
                                      value: _getPercent(
                                          storedocs[index]['balance'],
                                          storedocs[index]['remain']),
                                      color: _getPercent(
                                                  storedocs[index]['balance'],
                                                  storedocs[index]['remain']) <
                                              1
                                          ? AppStyle.blueColor
                                          : Colors.redAccent,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText(
                                        "${_getDayLeft(storedocs[index]['endDay'])} days left",
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        '${AppStyle.moneyFormat.format(storedocs[index]['balance'] - storedocs[index]['remain'])} ${storedocs[index]['currency']}',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: _getPercent(
                                                        storedocs[index]
                                                            ['balance'],
                                                        storedocs[index]
                                                            ['remain']) <
                                                    1
                                                ? AppStyle.blueColor
                                                : Colors.redAccent),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: [
                            IconSlideAction(
                              onTap: () => _deleteDialog(
                                  context, storedocs[index]['id']),
                              color: Color(0xfff1f4f8),
                              iconWidget: Padding(
                                padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: AppStyle.mainBorder),
                                  child: Icon(
                                    Icons.delete,
                                    color: AppStyle.lightColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return AddBudgetPage(
                                userRepository: _userRepository,
                                categoryRepository: _categoryRepository,
                              );
                            }));
                          },
                          borderRadius: AppStyle.mainBorder,
                          splashColor: AppStyle.blueColor,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: DottedDecoration(
                              borderRadius: AppStyle.mainBorder,
                              shape: Shape.box,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Icon(
                                    FontAwesomeIcons.wallet,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    "Add New Budget",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
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
        } else if (snapshot.hasError) {
          return Text('no data');
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _deleteDialog(BuildContext context, String wid) async {
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
                  "Deleting this Budget, Deleted data cannot be recovered. Are you sure you want to proceed?",
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
                            _userRepository.deleteBudget(wid);
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
}
