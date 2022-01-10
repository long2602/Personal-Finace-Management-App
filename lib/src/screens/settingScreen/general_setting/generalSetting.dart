import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';

class SettingGeneral extends StatefulWidget {
  const SettingGeneral({Key? key}) : super(key: key);

  @override
  _SettingGeneralState createState() => _SettingGeneralState();
}

class _SettingGeneralState extends State<SettingGeneral> {
  bool protectionCode = false;
  bool fingerPrint = false;
  bool dataEntryReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
          "General",
          AppBarBtn(
              onPressed: () {
                Navigator.pop(context);
              },
              isAlign: true,
              icon: Icons.arrow_back),
          Padding(
            padding: const EdgeInsets.only(right: 4, left: 15),
            child: SizedBox(
              width: 45,
            ),
          )),
      body: Column(
        children: [
          //Display
          OptionContainer(
            width: double.infinity,
            padding: EdgeInsets.only(top: 20, left: 30, right: 20, bottom: 25),
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 20),
                  child: Text(
                    "Display",
                    style: TextStyle(
                      color: Color(0xff9499F0),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Language",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppStyle.textColor,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        "English",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20,
                          color: AppStyle.blueColor,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xff2934E1),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(
                        "Currency Unit",
                        style: TextStyle(
                          fontSize: 20,
                          color: AppStyle.textColor,
                        ),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          "VND",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 20,
                            color: AppStyle.blueColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xff2934E1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //Security
          OptionContainer(
            width: double.infinity,
            padding: EdgeInsets.only(top: 20, left: 30, right: 20, bottom: 25),
            margin: EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 10),
                  child: Text(
                    "Security",
                    style: TextStyle(
                      color: Color(0xff9499F0),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Protection Code",
                        style: TextStyle(
                          fontSize: 20,
                          color: AppStyle.textColor,
                        ),
                      ),
                    ),
                    Container(
                      child: Switch(
                        value: protectionCode,
                        onChanged: (value) {
                          setState(() {
                            protectionCode = value;
                            print(protectionCode);
                          });
                        },
                        activeTrackColor: Color(0xffA8ACF2),
                        activeColor: Color(0xff2934E1),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Change Protection Code",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppStyle.textColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Finger Print",
                        style: TextStyle(
                          fontSize: 20,
                          color: AppStyle.textColor,
                        ),
                      ),
                    ),
                    Container(
                      child: Switch(
                        value: fingerPrint,
                        onChanged: (value) {
                          setState(() {
                            fingerPrint = value;
                            print(fingerPrint);
                          });
                        },
                        activeTrackColor: Color(0xffA8ACF2),
                        activeColor: Color(0xff2934E1),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Language",
                        style: TextStyle(
                          fontSize: 20,
                          color: AppStyle.textColor,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xff2934E1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // OptionContainer(
          //   width: double.infinity,
          //   padding: EdgeInsets.only(top: 20, left: 30, right: 20, bottom: 25),
          //   margin: EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 20),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(top: 6, bottom: 10),
          //         child: Text(
          //           "Remind",
          //           style: TextStyle(
          //             color: Color(0xff9499F0),
          //             fontWeight: FontWeight.bold,
          //             fontSize: 20,
          //           ),
          //         ),
          //       ),
          //       Row(
          //         children: [
          //           Expanded(
          //             child: Text(
          //               "Data Entry Reminder",
          //               style: TextStyle(
          //                 fontSize: 20,
          //                 color: AppStyle.textColor,
          //               ),
          //             ),
          //           ),
          //           Container(
          //             child: Switch(
          //               value: dataEntryReminder,
          //               onChanged: (value) {
          //                 setState(() {
          //                   dataEntryReminder = value;
          //                   print(dataEntryReminder);
          //                 });
          //               },
          //               activeTrackColor: Color(0xffA8ACF2),
          //               activeColor: Color(0xff2934E1),
          //             ),
          //           ),
          //         ],
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(
          //           right: 80,
          //         ),
          //         child: AutoSizeText(
          //           "The system will send a notification reminding you to enter daily income and expenditure data. ",
          //           style: TextStyle(
          //             fontSize: 15,
          //             color: Color(0xff7F7F7F),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
