import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loda_app/src/blocs/tab_bloc.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/events/tab_event.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/homeScreen/homePage.dart';
import 'package:loda_app/src/screens/reportScreen/report.dart';
import 'package:loda_app/src/screens/settingScreen/settingPage.dart';
import 'package:loda_app/src/screens/transactionScreen/addTransaction/addTransactionPage.dart';
import 'package:loda_app/src/screens/walletScreen/walletPage.dart';
import 'package:loda_app/src/states/tab_state.dart';
import 'package:loda_app/src/widgets/FAB_widget.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:loda_app/src/widgets/navigationBar.dart';

class HousePage extends StatefulWidget {
  final UserRepository _userRepository;
  final String _uid;
  // final Users _user;
  const HousePage({
    Key? key,
    required UserRepository userRepository,
    required String uid,
  })  : _userRepository = userRepository,
        _uid = uid,
        // _user = user,
        super(key: key);

  @override
  _HousePageState createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  UserRepository get _userRepository => widget._userRepository;
  String get _uid => widget._uid;
  late CategoryRepository _categoryRepository = CategoryRepository();
  // late Map _walletSelected = Map<String, dynamic>();
  @override
  void initState() {
    print("init house");
    super.initState();
  }

  // void getWallet() async {
  //   final data = await _userRepository.getSelectedWallet();
  //   data.docs.forEach((element) {
  //     _walletSelected = element.data() as Map<String, dynamic>;
  //   });
  //   print(_walletSelected);
  // }

  @override
  Widget build(BuildContext context) {
    print("build house");
    return BlocBuilder<TabBloc, TabState>(
      builder: (context, selectedTab) {
        if (selectedTab is TabInitialState) {
          BlocProvider.of<TabBloc>(context).add(TabEventChangeHomeTab());
        }
        return Scaffold(
          backgroundColor: AppStyle.backgroundColor,
          appBar: onAppBar(context, selectedTab),
          body: onBody(context, selectedTab),
          floatingActionButton: Container(
            width: 65.sp,
            height: 65.sp,
            child: FloatingActionButton(
              onPressed: () async {
                final test = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionPage(
                      categoryRepository: _categoryRepository,
                      userRepository: _userRepository,
                    ),
                  ),
                );
                if (test != null) setState(() {});
              },
              backgroundColor: AppStyle.blueColor,
              elevation: 6,
              child: FaIcon(
                // FontAwesomeIcons.solidFile,
                FontAwesomeIcons.plus,
                size: 30,
              ),
            ),
          ),
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Navigationbar(
            tab: selectedTab,
          ),
        );
      },
    );
  }

  onAppBar(context, state) {
    if (state is TabHomeState) {
      return null;
    } else if (state is TabWalletState) {
      return null;
    } else if (state is TabStatisticState) {
      return null;
    } else if (state is TabSettingState) {
      return GeneralAppbar("Setting", Container(), Container());
    }
  }

  onBody(context, state) {
    if (state is TabHomeState) {
      return HomePage(
        userRepository: _userRepository,
        categoryRepository: _categoryRepository,
        user: state.users,
        walletSelected: state.wallet,
      );
    } else if (state is TabWalletState) {
      return WalletPage(
        userRepository: _userRepository,
        user: state.users,
        categoryRepository: _categoryRepository,
        walletSelected: state.wallet,
      );
    } else if (state is TabStatisticState) {
      return ReportPage(
        userRepository: _userRepository,
        categoryRepository: _categoryRepository,
        walletSelected: state.wallet,
      );
    } else if (state is TabSettingState) {
      return SettingPage(
        users: state.users,
        userRepository: _userRepository,
      );
    }
  }
}
