import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';

class DetailBudgetPage extends StatefulWidget {
  final Map _budget;
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  const DetailBudgetPage({
    Key? key,
    required Map budget,
    required UserRepository userRepository,
    required CategoryRepository categoryRepository,
  })  : _budget = budget,
        _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        super(key: key);

  @override
  _DetailBudgetPageState createState() => _DetailBudgetPageState();
}

class _DetailBudgetPageState extends State<DetailBudgetPage> {
  Map get _budget => widget._budget;
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  late List _categories = [];
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
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Detail",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 4),
          child: SizedBox(
            width: 45,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: _userRepository.getTransactionsByRangeBudget(
              _budget['idWallet'],
              (_budget['startDay'] as Timestamp).toDate(),
              (_budget['endDay'] as Timestamp).toDate(),
              _budget['idCategory']),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final List storedocs = [];
                snapshot.data!.docs.map((DocumentSnapshot document) async {
                  Map a = document.data() as Map<String, dynamic>;
                  if (a['idCategory'] == _budget['idCategory']) {
                    storedocs.add(a);
                    a['id'] = document.id;
                    _categories.forEach((element) {
                      if (element['id'] == a['idCategory']) {
                        a['imgCategory'] = element['img'];
                        a['nameCategory'] = element['name'];
                      }
                    });
                  }
                }).toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppStyle.mainPadding),
                  child: Column(children: [
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
                            '${AppStyle.moneyFormat.format(_budget['remain'])} VNĐ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                        fontSize: 15.0,
                                        color: Color(0xffb57084)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ]),
                );
              }
            } else if (snapshot.hasError) {
              return Text('no data');
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
