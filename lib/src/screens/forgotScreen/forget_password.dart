import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({Key? key}) : super(key: key);

  @override
  _FogetPageState createState() => _FogetPageState();
}

class _FogetPageState extends State<ForgetPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppStyle.hintTextColor,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppStyle.hintTextColor,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
          "",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 17, left: 30, top: 20),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: AppStyle.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 31, right: 60, left: 30),
                child: Text(
                  "Enter an Email associated with your account and we’ll send an email with instruction to reset your password. ",
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    controller: _emailController,
                    onTap: () {
                      _emailController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _emailController.value.text.length);
                    },
                    style: TextStyle(fontSize: 20, color: AppStyle.textColor),
                    decoration: InputDecoration(
                      fillColor: AppStyle.lightColor,
                      filled: true,
                      labelText: "Email Address",
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Color(0xffA0A0A0),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffCED0D2)),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffEEEEEE), width: 0),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email';
                      } else if (!value.contains('@')) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 180),
                child: ClipRRect(
                  borderRadius: AppStyle.mainBorder,
                  child: MaterialButton(
                    minWidth: double.infinity,
                    color: AppStyle.blueColor,
                    elevation: 0,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        resetPassword(_emailController.text);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Reset Password",
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
          ),
        ),
      ),
    );
  }
}
