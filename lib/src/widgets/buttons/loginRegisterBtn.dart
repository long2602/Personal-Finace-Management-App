import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';

class LoginRegisterBtn extends StatelessWidget {
  VoidCallback _onPressed;
  String _title;
  LoginRegisterBtn(
      {Key? key, required VoidCallback onPressed, required String title})
      : _onPressed = onPressed,
        _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed,
      child: Text(
        _title.toUpperCase(),
        style: TextStyle(
          fontSize: 20.sp,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        elevation: 0,
        minimumSize: Size(240, 50),
        primary: AppStyle.blueColor,
      ),
    );
  }
}
