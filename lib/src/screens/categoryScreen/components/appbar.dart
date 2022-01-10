import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/screens/addCategoryScreen/addCategoryPage.dart';

// ignore: non_constant_identifier_names
AppBar Appbar(TabController _tabController, BuildContext context,
    CategoryRepository categoryRepository) {
  return AppBar(
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
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
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
                "Select category",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppStyle.textColor, fontSize: 26.sp),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCategoryPage(
                                  categoryRepository: categoryRepository,
                                )));
                  },
                  icon: Icon(
                    Icons.add,
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      labelColor: AppStyle.textColor,
      tabs: [
        Tab(
          child: Align(
            child: Text(
              "Expense",
              style: TextStyle(fontSize: 16),
            ),
            alignment: Alignment.center,
          ),
        ),
        Tab(
          child: Align(
            child: Text(
              "Income",
              style: TextStyle(fontSize: 16),
            ),
            alignment: Alignment.center,
          ),
        ),
      ],
    ),
  );
}
