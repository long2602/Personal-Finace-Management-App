import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/blocs/account_bloc.dart';
import 'package:loda_app/src/blocs/authentication_bloc.dart';
import 'package:loda_app/src/blocs/tab_bloc.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/events/authentication_event.dart';
import 'package:loda_app/src/events/tab_event.dart';
import 'package:loda_app/src/models/user.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/accountScreen/accountPage.dart';
import 'package:loda_app/src/screens/changePassScreen/changePassPage.dart';
import 'package:loda_app/src/screens/settingScreen/general_setting/generalSetting.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/optionBtn.dart';

class SettingPage extends StatelessWidget {
  final Users _users;
  final UserRepository _userRepository;
  const SettingPage(
      {Key? key, required Users users, required UserRepository userRepository})
      : _users = users,
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          right: AppStyle.mainPadding, left: AppStyle.mainPadding, bottom: 40),
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppStyle.mainPadding + 14, vertical: 50.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(41, 52, 225, .25),
              borderRadius: AppStyle.mainBorder,
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 60.h,
                      backgroundImage: _users.img!.isNotEmpty
                          ? NetworkImage(_users.img!)
                          : AssetImage(AppUI.ava1) as ImageProvider,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: AutoSizeText(
                    _users.name,
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
                AutoSizeText(
                  _users.email,
                  style: TextStyle(fontSize: 20.sp),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          OptionContainer(
            child: Column(
              children: [
                optionBtn(
                  title: "General",
                  icon: Icons.tune,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingGeneral()));
                  },
                ),
                optionBtn(
                  title: "Account",
                  icon: Icons.account_circle,
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return BlocProvider<AccountBloc>(
                          create: (context) => AccountBloc(
                              userRepository: _userRepository, user: _users),
                          child: AccountPage(),
                        );
                      }),
                    );
                    if (result != null) {
                      BlocProvider.of<TabBloc>(context)
                          .add(TabEventChangeSettingTab());
                    }
                  },
                ),
                optionBtn(
                  title: "Change password",
                  icon: Icons.lock,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassPage(
                                  userRepository: _userRepository,
                                )));
                  },
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
                onPressed: () => _logoutDialog(context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Log out",
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
    );
  }

  Future<void> _logoutDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context1) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppUI.logout,
                width: 100.w,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 22),
                child: Text(
                  "Are you sure you want to log out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: AppStyle.mainBorder,
                        child: MaterialButton(
                          minWidth: double.infinity,
                          color: AppStyle.backgroundColor,
                          elevation: 0,
                          onPressed: () => Navigator.pop(context1, 'No'),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppStyle.hintTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius: AppStyle.mainBorder,
                        child: MaterialButton(
                          minWidth: double.infinity,
                          color: AppStyle.blueColor,
                          elevation: 0,
                          onPressed: () {
                            Navigator.pop(context1, 'Yes');
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(AuthenticationEventLoggedOut());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppStyle.lightColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: AppStyle.mainBorder),
      ),
      barrierDismissible: false,
    );
  }
}
