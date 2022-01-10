import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';

// ignore: non_constant_identifier_names
AppBar GeneralAppbar(String title, Widget wid1, Widget wid2) {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    toolbarHeight: 70,
    backgroundColor: AppStyle.backgroundColor,
    title: Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppStyle.backgroundColor),
      child: Row(
        children: [
          wid1,
          Expanded(
            child: Container(
              child: AutoSizeText(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppStyle.textColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
          ),
          wid2,
        ],
      ),
    ),
  );
}
