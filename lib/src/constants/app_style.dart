import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppStyle {
  //radius
  static final BorderRadius mainBorder = BorderRadius.circular(15);

  //shadow
  static final BoxShadow mainShadow = BoxShadow(
      color: Colors.grey.withOpacity(.3),
      spreadRadius: 8,
      blurRadius: 2,
      offset: Offset(0, 1));

  //padding
  // static final Padding mainPadding = Padding(padding: EdgeInsets.all(20));
  static const double mainPadding = 20.0;

  //Color
  static final Color backgroundColor = Color(0xfff1f4f8);
  static final Color textColor = Colors.black;
  static final Color lightColor = Colors.white;
  // static final Color backgroundColor = Color(0xff292929);
  // static final Color textColor = Color(0xff7F7F7F);
  // static final Color lightColor = Color(0xff505050);
  static final Color lighTextColor = Color.fromRGBO(255, 255, 255, .75);
  static final Color hintTextColor = Colors.grey.shade600;

  static final Color blueColor = Color(0xff438DF6);
  static final Color lightBlueColor = Color(0xff476072);
  static final Color redColor = Color(0xffed6c77);
  static final Color inputColor = Color(0xffeeeeee);

  //format money
  static final moneyFormat = new NumberFormat("#,##0", "en_US");
}

//505050
//292929
//7F7F7F