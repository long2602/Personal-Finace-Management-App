import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:loda_app/src/widgets/snackBar.dart';

class ChangePassPage extends StatefulWidget {
  final UserRepository _userRepository;
  const ChangePassPage({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();
  UserRepository get _userRepository => widget._userRepository;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Change password",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        SizedBox(
          width: 45,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(AppUI.repass2x),
                  ),
                  OptionContainer(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _passController,
                            autocorrect: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: AppStyle.inputColor,
                              filled: true,
                              labelText: "password",
                              labelStyle: TextStyle(
                                  fontSize: 18.sp, color: AppStyle.textColor),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffCED0D2)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffEEEEEE), width: 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: AppStyle.blueColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value == null) {
                                return "Please enter password";
                              } else if (value.length < 8) {
                                return "Password need to have 8 or more characters";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _repassController,
                            autocorrect: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: AppStyle.inputColor,
                              filled: true,
                              labelText: "new password",
                              labelStyle: TextStyle(
                                  fontSize: 18.sp, color: AppStyle.textColor),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffCED0D2)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffEEEEEE), width: 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: AppStyle.blueColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value == null) {
                                return "Please enter new password";
                              } else if (value.length < 8) {
                                return "Password need to have 8 or more characters";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: ClipRRect(
                      borderRadius: AppStyle.mainBorder,
                      child: MaterialButton(
                        minWidth: double.infinity,
                        color: AppStyle.blueColor,
                        elevation: 0,
                        onPressed: () async {
                          // _userRepository.changePassword(_repassController.text);

                          if (_formKey.currentState!.validate()) {
                            try {
                              final result = await _userRepository.reAuthen(
                                  _passController.text, _repassController.text);
                              if (result == true) {
                                WidgetsBinding.instance!.addPostFrameCallback(
                                    (_) => createSnackBar(
                                        "Change password successfully",
                                        context));
                                Navigator.pop(context);
                              } else {
                                _passController.text = "";
                                _repassController.text = "";
                                WidgetsBinding.instance!.addPostFrameCallback(
                                    (_) => createSnackBar(
                                        "Change password Fail", context));
                              }
                            } catch (_) {}
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Change Password",
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
