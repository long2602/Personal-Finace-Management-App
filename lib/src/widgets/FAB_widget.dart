import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/transactionScreen/addTransaction/addTransactionPage.dart';

class FabAdd extends StatefulWidget {
  final CategoryRepository _categoryRepository;
  final UserRepository _userRepository;
  @override
  FabAdd(
      {Key? key,
      required CategoryRepository categoryRepository,
      required UserRepository userRepository})
      : _categoryRepository = categoryRepository,
        _userRepository = userRepository,
        super(key: key);

  @override
  State<FabAdd> createState() => _FabAddState();
}

class _FabAddState extends State<FabAdd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65.sp,
      height: 65.sp,
      child: FloatingActionButton(
        onPressed: () async {
          final test = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionPage(
                categoryRepository: widget._categoryRepository,
                userRepository: widget._userRepository,
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
    );
  }
}
