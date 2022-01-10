import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';

class optionBtn extends StatelessWidget {
  VoidCallback _onPressed;
  String _title;
  IconData _icon;
  optionBtn({
    Key? key,
    required String title,
    required VoidCallback onPressed,
    required IconData icon,
  })  : _icon = icon,
        _title = title,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 16.0),
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppStyle.backgroundColor,
                  borderRadius: AppStyle.mainBorder,
                ),
                child: Icon(
                  _icon,
                  size: 32.sp,
                ),
              ),
              Expanded(
                child: Container(
                  child: AutoSizeText(
                    _title,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 28.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
