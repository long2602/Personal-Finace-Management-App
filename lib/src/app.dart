import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/blocs/authentication_bloc.dart';
import 'package:loda_app/src/blocs/login_bloc.dart';
import 'package:loda_app/src/blocs/tab_bloc.dart';
import 'package:loda_app/src/events/authentication_event.dart';
import 'package:loda_app/src/house_page.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/loginScreen/loginPage.dart';
import 'package:loda_app/src/states/authentication_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final UserRepository _userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    //Set the fit size (fill in the screen size of the device in the design) If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Fail");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ScreenUtilInit(
            designSize: Size(428, 848),
            builder: () => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'LoDa App',
              theme: ThemeData(
                // primarySwatch: AppStyle.backgroundColor,
                textTheme: TextTheme(button: TextStyle(fontSize: 18.sp)),
              ),
              builder: (context, widget) {
                return MediaQuery(
                  //Setting font does not change with system font size
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                );
              },
              home: BlocProvider(
                create: (context) =>
                    AuthenticationBloc(userRepository: _userRepository)
                      ..add(AuthenticationEventStarted()),
                child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, authenticationState) {
                    if (authenticationState is AuthenticationStateSuccess) {
                      keepLogin(authenticationState.user.uid);
                      print(authenticationState.user.uid);
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider<TabBloc>(
                            create: (context) =>
                                TabBloc(userRepository: _userRepository),
                          ),
                        ],
                        child: HousePage(
                          userRepository: _userRepository,
                          uid: authenticationState.user.uid,
                        ),
                      );
                    } else if (authenticationState
                        is AutheticationStateFailure) {
                      return BlocProvider<LoginBloc>(
                        create: (context) => LoginBloc(_userRepository),
                        child: LoginPage(userRepository: _userRepository),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  void keepLogin(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("IDCURRENT", id);
  }
}
