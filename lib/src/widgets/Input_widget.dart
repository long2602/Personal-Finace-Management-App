import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';

//input login/register
// ignore: non_constant_identifier_names
Padding Input_widget(String label, IconData, TextEditingController controller,
    TextInputType type, bool isPassword, bool isValidate, String error) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
      controller: controller,
      autocorrect: false,
      keyboardType: type,
      obscureText: isPassword,
      onTap: () {
        controller.selection = TextSelection(
            baseOffset: 0, extentOffset: controller.value.text.length);
      },
      decoration: InputDecoration(
        fillColor: AppStyle.inputColor,
        filled: true,
        labelText: label,
        labelStyle: TextStyle(fontSize: 18.sp, color: AppStyle.textColor),
        prefixIcon: Container(
          width: 50.sp,
          child: Icon(
            IconData,
            color: AppStyle.textColor,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Color(0xffCED0D2)),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffEEEEEE), width: 0),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
      ),
      validator: (_) {
        return isValidate ? error : error;
      },
    ),
  );
}
