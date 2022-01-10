import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/blocs/register_bloc.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/events/register_event.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/states/register_state.dart';
import 'package:loda_app/src/validators/validators.dart';
import 'package:loda_app/src/widgets/Input_widget.dart';
import 'package:loda_app/src/widgets/buttons/loginRegisterBtn.dart';
import 'package:loda_app/src/widgets/snackBar.dart';

class RegisterPage extends StatefulWidget {
  final UserRepository _userRepository;
  RegisterPage({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  UserRepository get _userRepository => widget._userRepository;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwodController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  late RegisterBloc _registerBloc;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(() {
      _registerBloc
          .add(RegisterEventEmailChanged(email: _emailController.text));
    });

    _nameController.addListener(() {
      _registerBloc.add(RegisterEventNameChanged(name: _nameController.text));
    });

    _passwodController.addListener(() {
      _registerBloc
          .add(RegisterEventPasswordChanged(password: _passwodController.text));
    });

    _repasswordController.addListener(() {
      _registerBloc.add(RegisterEventCheckPassAndConfirmPass(
          pass: _passwodController.text, rePass: _repasswordController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            if (registerState.isFailure) {
              print("Email already exists");
              WidgetsBinding.instance!.addPostFrameCallback(
                  (_) => createSnackBar("Register failed", context));
            } else if (registerState.isSubmitting) {
              print('Registration in progress...');
            } else if (registerState.isSuccess) {
              WidgetsBinding.instance!.addPostFrameCallback(
                  (_) => createSnackBar("Register Successfully", context));
            }
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(AppStyle.mainPadding),
              height: double.infinity,
              color: AppStyle.backgroundColor,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Image.asset(
                          AppUI.logo,
                          height: MediaQuery.of(context).size.height * .15,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: AppStyle.lightColor,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(AppStyle.mainPadding + 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.sp,
                                    color: AppStyle.textColor,
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    //input email

                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        controller: _nameController,
                                        autocorrect: false,
                                        keyboardType: TextInputType.text,
                                        obscureText: false,
                                        onTap: () {
                                          _nameController.selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset: _nameController
                                                      .value.text.length);
                                        },
                                        decoration: InputDecoration(
                                          fillColor: AppStyle.inputColor,
                                          filled: true,
                                          labelText: "Name",
                                          labelStyle: TextStyle(
                                              fontSize: 18.sp,
                                              color: AppStyle.textColor),
                                          prefixIcon: Container(
                                            width: 50.sp,
                                            child: Icon(
                                              Icons.person,
                                              color: AppStyle.textColor,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xffCED0D2)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.r)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffEEEEEE),
                                                width: 0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.r)),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty || value == null) {
                                            return "Please input name";
                                          } else if (isValidator
                                                  .isValidName(value) ==
                                              false) {
                                            return "Invalid name format";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        controller: _emailController,
                                        autocorrect: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        obscureText: false,
                                        onTap: () {
                                          _emailController.selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset: _emailController
                                                      .value.text.length);
                                        },
                                        decoration: InputDecoration(
                                          fillColor: AppStyle.inputColor,
                                          filled: true,
                                          labelText: "Email",
                                          labelStyle: TextStyle(
                                              fontSize: 18.sp,
                                              color: AppStyle.textColor),
                                          prefixIcon: Container(
                                            width: 50.sp,
                                            child: Icon(
                                              Icons.person,
                                              color: AppStyle.textColor,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xffCED0D2)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.r)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffEEEEEE),
                                                width: 0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.r)),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty || value == null) {
                                            return "Please input email";
                                          } else if (isValidator
                                                  .isValidEmail(value) ==
                                              false) {
                                            return "Invalid email format";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        controller: _passwodController,
                                        autocorrect: false,
                                        keyboardType: TextInputType.text,
                                        obscureText: true,
                                        onTap: () {
                                          _passwodController.selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      _passwodController
                                                          .value.text.length);
                                        },
                                        decoration: InputDecoration(
                                          fillColor: AppStyle.inputColor,
                                          filled: true,
                                          labelText: "Password",
                                          labelStyle: TextStyle(
                                              fontSize: 18.sp,
                                              color: AppStyle.textColor),
                                          prefixIcon: Container(
                                            width: 50.sp,
                                            child: Icon(
                                              Icons.lock,
                                              color: AppStyle.textColor,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xffCED0D2)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.r)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffEEEEEE),
                                                width: 0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.r)),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty || value == null) {
                                            return "Please input password";
                                          } else if (isValidator
                                                  .isValidPassword(value) ==
                                              false) {
                                            return "Invalid password format";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        controller: _repasswordController,
                                        autocorrect: false,
                                        keyboardType: TextInputType.text,
                                        obscureText: true,
                                        onTap: () {
                                          _repasswordController.selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      _repasswordController
                                                          .value.text.length);
                                        },
                                        decoration: InputDecoration(
                                          fillColor: AppStyle.inputColor,
                                          filled: true,
                                          labelText: "Confirm Password",
                                          labelStyle: TextStyle(
                                              fontSize: 18.sp,
                                              color: AppStyle.textColor),
                                          prefixIcon: Container(
                                            width: 50.sp,
                                            child: Icon(
                                              Icons.lock,
                                              color: AppStyle.textColor,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xffCED0D2)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.r)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffEEEEEE),
                                                width: 0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.r)),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty || value == null) {
                                            return "Please input password";
                                          } else if (isValidator
                                                  .isValidPassword(value) ==
                                              false) {
                                            return "Invalid password format";
                                          } else if (isValidator
                                                      .isValidConfirmPassword(
                                                          _passwodController
                                                              .text,
                                                          value) ==
                                                  false &&
                                              value != null) {
                                            return "The password confirmation doesn't match";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    //button signin
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: LoginRegisterBtn(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _registerBloc
                                                .add(RegisterEventPressed(
                                              email: _emailController.text,
                                              password: _passwodController.text,
                                              name: _nameController.text,
                                              confirmPassword:
                                                  _repasswordController.text,
                                            ));
                                          }
                                        },
                                        title: "Sign Up",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      child: AutoSizeText(
                                        "Already have an account?",
                                        style: TextStyle(
                                          color: AppStyle.textColor,
                                          fontSize: 20,
                                        ),
                                        maxLines: 1,
                                      ),
                                    )),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Login Now",
                                            style: TextStyle(
                                              color: AppStyle.blueColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
