import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/blocs/authentication_bloc.dart';
import 'package:loda_app/src/blocs/login_bloc.dart';
import 'package:loda_app/src/blocs/register_bloc.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/events/authentication_event.dart';
import 'package:loda_app/src/events/login_event.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/forgotScreen/forget_password.dart';
import 'package:loda_app/src/screens/registerScreen/registerPage.dart';
import 'package:loda_app/src/states/login_state.dart';
import 'package:loda_app/src/validators/validators.dart';
import 'package:loda_app/src/widgets/buttons/loginRegisterBtn.dart';
import 'package:loda_app/src/widgets/snackBar.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;
  //constructor
  LoginPage({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwodController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  late LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();

    _loginBloc = BlocProvider.of<LoginBloc>(context);
    // fetchData();
    _emailController.addListener(() {
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });

    _passwodController.addListener(() {
      _loginBloc
          .add(LoginEventPasswordChanged(password: _passwodController.text));
    });
  }

  // fetchData() async {
  //   dynamic list = await CategoryRepository().getCategoriesListByType(1);
  //   if (list != null)
  //     print(list);
  //   else
  //     print("fail");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state.isFailure) {
              print("Login failed");
              WidgetsBinding.instance!.addPostFrameCallback(
                  (_) => createSnackBar("Login failed", context));
            } else if (state.isSubmitting) {
              print("Logging in");
            } else if (state.isSuccess) {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventLoggedIn());
            }
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(AppStyle.mainPadding.w),
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
                          padding: const EdgeInsets.all(AppStyle.mainPadding),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Sign In",
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

                                    //input password

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
                                    //forget pass
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForgetPage()));
                                        },
                                        child: Text(
                                          "Forgot password?",
                                          style: TextStyle(
                                            color: AppStyle.textColor,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //button signin
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LoginRegisterBtn(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _loginBloc.add(
                                                LoginEventWithEmailAndPasswordPressed(
                                                    email:
                                                        _emailController.text,
                                                    password: _passwodController
                                                        .text));
                                          }
                                        },
                                        title: "Sign In",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      child: AutoSizeText(
                                        "Don't have an account",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: AppStyle.textColor,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return BlocProvider<
                                                        RegisterBloc>(
                                                    create: (context) =>
                                                        RegisterBloc(
                                                            userRepository:
                                                                _userRepository),
                                                    child: RegisterPage(
                                                        userRepository:
                                                            _userRepository));
                                              }),
                                            );
                                          },
                                          child: AutoSizeText(
                                            "Register Now",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: AppStyle.blueColor,
                                              fontSize: 18.sp,
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
