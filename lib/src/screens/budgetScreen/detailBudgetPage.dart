import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';

class DetailBudgetPage extends StatefulWidget {
  final List _transaction;
  final num _total;
  const DetailBudgetPage(
      {Key? key, required List transaction, required num total})
      : _transaction = transaction,
        _total = total,
        super(key: key);

  @override
  _DetailBudgetPageState createState() => _DetailBudgetPageState();
}

class _DetailBudgetPageState extends State<DetailBudgetPage> {
  List get _transactions => widget._transaction;
  num get _total => widget._total;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
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
                  '${AppStyle.moneyFormat.format(_total)} VNĐ',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ],
            ),
          ),
          GroupedListView<dynamic, String>(
              shrinkWrap: true,
              primary: false,
              elements: _transactions,
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
                    onTap: () {},
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
                              fontSize: 15.0, color: Color(0xffb57084)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ]),
      ),
    );
  }
}
