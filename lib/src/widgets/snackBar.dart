import 'package:flutter/material.dart';
import 'package:loda_app/src/constants/app_style.dart';

void createSnackBar(String message, BuildContext context) {
  final snackBar = new SnackBar(
    content: new Text(message),
    backgroundColor: AppStyle.hintTextColor,
    shape: StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
