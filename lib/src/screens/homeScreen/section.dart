import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/models/user.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Appbar
// ignore: non_constant_identifier_names
Container AppbarSection(Users user) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundImage: user.img!.isNotEmpty
                  ? NetworkImage(user.img!)
                  : AssetImage(AppUI.ava1) as ImageProvider,
            ),
            SizedBox(
              width: 14.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Hello,",
                  style: TextStyle(fontSize: 20.sp),
                ),
                AutoSizeText(
                  user.name,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  maxFontSize: 30.sp,
                ),
              ],
            ),
          ],
        ),
        AppBarBtn(onPressed: () {}, isAlign: false, icon: Icons.history)
      ],
    ),
  );
}

//ATM
// ignore: non_constant_identifier_names
Widget ATMSection(
    BuildContext context, Users _user, UserRepository userRepository) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        print("tap");
      },
      child: FutureBuilder<QuerySnapshot>(
        future: userRepository.getSelectedWallet(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  color: AppStyle.blueColor,
                  borderRadius: AppStyle.mainBorder,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(40, 25, 40, 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Balance",
                                  style: TextStyle(
                                      color: AppStyle.lighTextColor,
                                      fontSize: 20),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: AutoSizeText(
                                    "${AppStyle.moneyFormat.format(a['remain'] ?? 0)} ${a['currency']}",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wallet Holder",
                                  style: TextStyle(
                                      color: AppStyle.lighTextColor,
                                      fontSize: 20.sp),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
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
                            color: Color.fromRGBO(255, 255, 255, .25),
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
  );
}

void keepWallet(Map a) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("WALLET", jsonEncode(a));
}
//Char Expense and 
