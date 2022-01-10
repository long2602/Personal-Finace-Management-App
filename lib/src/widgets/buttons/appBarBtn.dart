import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';

class AppBarBtn extends StatelessWidget {
  VoidCallback _onPressed;
  bool _isAlign;
  IconData _icon;
  AppBarBtn({
    Key? key,
    required VoidCallback onPressed,
    required bool isAlign,
    required IconData icon,
  })  : _icon = icon,
        _isAlign = isAlign,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _isAlign
          ? const EdgeInsets.only(left: 4, right: 15)
          : const EdgeInsets.only(left: 15, right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onPressed,
          borderRadius: AppStyle.mainBorder,
          splashColor: AppStyle.blueColor,
          child: Container(
            height: 45.h,
            width: 45.w,
            decoration: BoxDecoration(
              color: AppStyle.lightColor,
              borderRadius: AppStyle.mainBorder,
            ),
            child: Center(
              child: Icon(
                _icon,
                color: AppStyle.blueColor,
                size: 28.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
