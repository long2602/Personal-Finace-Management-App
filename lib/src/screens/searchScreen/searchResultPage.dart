import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/transactionScreen/viewTransaction/viewTransactionPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';

class SearchResultPage extends StatelessWidget {
  List _result;
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final Map _walletSelected;
  final List _categories;

  SearchResultPage(
      {Key? key,
      required List result,
      required UserRepository userRepository,
      required CategoryRepository categoryRepository,
      required Map walletSelected,
      required List categories})
      : _result = result,
        _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        _walletSelected = walletSelected,
        _categories = categories,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    num tongE = 0;
    num tongI = 0;
    final List storedocs = [];
    _result.forEach((value) {
      Map element = value.data() as Map<String, dynamic>;
      _categories.forEach((e) {
        if (e['id'] == element['idCategory']) {
          element['imgCategory'] = e['img'];
          element['nameCategory'] = e['name'];
        }
      });
      storedocs.add(element);
      element['id'] = value.id;
      if (element['type'] == true)
        tongE += element['money'];
      else
        tongI += element['money'];
    });
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Search Result",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        AppBarBtn(onPressed: () {}, isAlign: false, icon: Icons.done),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
          child: Column(
            children: [
              OptionContainer(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: AutoSizeText(
                        '${storedocs.length.toString()} results',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          "Income",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          '${AppStyle.moneyFormat.format(tongI)} VNĐ',
                          maxLines: 1,
                          style: TextStyle(
                              color: Color(0xff5985b5), fontSize: 18.sp),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          "Expense",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          '${AppStyle.moneyFormat.format(tongE)} VNĐ',
                          maxLines: 1,
                          style: TextStyle(
                              color: Color(0xffb57084), fontSize: 18.sp),
                        ),
                      ],
                    ),
                    Divider(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: AutoSizeText(
                        '${AppStyle.moneyFormat.format(tongI - tongE)} VNĐ',
                        maxLines: 1,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppStyle.mainPadding),
                child: GroupedListView<dynamic, String>(
                  shrinkWrap: true,
                  primary: false,
                  elements: storedocs,
                  // itemComparator: (item1, item2) => item1['money']
                  //     .compareTo(item2['money']), // optional
                  // useStickyGroupSeparators: true, // optional
                  // floatingHeader: false, // optional
                  // order: GroupedListOrder.ASC,
                  groupBy: (element) {
                    DateTime dt = (element['createAt'] as Timestamp).toDate();
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewTransactionPage(
                              transaction: element,
                              userRepository: _userRepository,
                              wallet: _walletSelected,
                              categoryRepository: _categoryRepository,
                            );
                          }));
                        },
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(element['imgCategory']),
                          radius: 20.0,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                color: element['type'] == true
                                    ? Color(0xffb57084)
                                    : Color(0xff5985b5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
