import 'package:flutter/material.dart';
import 'package:loda_app/src/constants/app_style.dart';

class OptionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width, height;
  final EdgeInsets? margin;
  const OptionContainer({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20.0),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        color: AppStyle.lightColor,
        borderRadius: AppStyle.mainBorder,
      ),
      child: child,
    );
  }
}
