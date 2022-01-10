// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';

class InputNoLabel extends StatelessWidget {
  String _text;
  TextInputType _type;
  bool _isEnable;
  TextEditingController _controller;
  InputNoLabel({
    Key? key,
    required bool isEnable,
    required String text,
    required TextInputType type,
    required TextEditingController controller,
  })  : _isEnable = isEnable,
        _type = type,
        _text = text,
        _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        onTap: () {
          _controller.selection = TextSelection(
              baseOffset: 0, extentOffset: _controller.value.text.length);
        },
        controller: _controller,
        autocorrect: false,
        keyboardType: _type,
        obscureText: false,
        decoration: InputDecoration(
          enabled: _isEnable,
          fillColor: AppStyle.inputColor,
          filled: true,
          hintText: _text,
          hintStyle: TextStyle(fontSize: 18.sp),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xffCED0D2)),
            borderRadius: BorderRadius.all(Radius.circular(15.r)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffEEEEEE), width: 0),
            borderRadius: BorderRadius.all(Radius.circular(15.r)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: AppStyle.blueColor),
            borderRadius: BorderRadius.all(Radius.circular(15.r)),
          ),
        ),
      ),
    );
  }
}
