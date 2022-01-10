import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loda_app/src/constants/app_style.dart';

class BtnDropDown_widget extends StatefulWidget {
  const BtnDropDown_widget({Key? key}) : super(key: key);

  @override
  State<BtnDropDown_widget> createState() => _MBtnDropDownWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MBtnDropDownWidgetState extends State<BtnDropDown_widget> {
  String dropdownValue = 'Add Expense';
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: FaIcon(
          FontAwesomeIcons.caretDown,
          color: AppStyle.textColor,
        ),
        iconSize: 26,
        style: TextStyle(
          color: AppStyle.textColor,
          fontSize: 26,
          fontWeight: FontWeight.w600,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: <String>['Add Expense', 'Add Income']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
