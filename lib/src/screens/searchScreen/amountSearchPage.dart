import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';

class amountSearchPage extends StatefulWidget {
  final bool _isBetween;
  const amountSearchPage({Key? key, required bool isBetween})
      : _isBetween = isBetween,
        super(key: key);

  @override
  _amountSearchPageState createState() => _amountSearchPageState();
}

class _amountSearchPageState extends State<amountSearchPage> {
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _moneyController1 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool get _isBetween => widget._isBetween;
  @override
  void initState() {
    _moneyController.text = "0";
    _moneyController1.text = "0";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Enter Amount",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 15),
          child: SizedBox(
            width: 45,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
          child: _isBetween == false
              ? Column(
                  children: [
                    TextField(
                      onSubmitted: (value) {
                        Navigator.pop(context, value);
                      },
                      onTap: () {
                        _moneyController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _moneyController.value.text.length);
                      },
                      controller: _moneyController,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      decoration: InputDecoration(
                        fillColor: AppStyle.lightColor,
                        filled: true,
                        hintStyle: TextStyle(fontSize: 18.sp),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffCED0D2)),
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffEEEEEE), width: 0),
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: AppStyle.blueColor),
                          borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        ),
                      ),
                    ),
                  ],
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Text(
                          "From",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.sp),
                        ),
                      ),
                      TextFormField(
                        onTap: () {
                          _moneyController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _moneyController.value.text.length);
                        },
                        controller: _moneyController,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          fillColor: AppStyle.lightColor,
                          filled: true,
                          hintStyle: TextStyle(fontSize: 18.sp),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffCED0D2)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffEEEEEE), width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: AppStyle.blueColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please input money";
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Text(
                          "To",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.sp),
                        ),
                      ),
                      TextFormField(
                        onTap: () {
                          _moneyController1.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset:
                                  _moneyController1.value.text.length);
                        },
                        controller: _moneyController1,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          fillColor: AppStyle.lightColor,
                          filled: true,
                          hintStyle: TextStyle(fontSize: 18.sp),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xffCED0D2)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffEEEEEE), width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: AppStyle.blueColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please input money";
                          } else if (num.parse(value) <=
                              num.parse(_moneyController.text)) {
                            return "'To Money' must be larger than 'From Money'";
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ClipRRect(
                          borderRadius: AppStyle.mainBorder,
                          child: MaterialButton(
                            minWidth: double.infinity,
                            color: AppStyle.blueColor,
                            elevation: 0,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context, [
                                  _moneyController.text,
                                  _moneyController1.text
                                ]);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppStyle.lightColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
