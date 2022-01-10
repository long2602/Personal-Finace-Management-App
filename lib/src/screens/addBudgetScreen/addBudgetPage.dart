import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/categoryScreen/categoryPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:loda_app/src/widgets/snackBar.dart';
import 'package:loda_app/src/widgets/text_input_formater.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBudgetPage extends StatefulWidget {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;

  const AddBudgetPage({
    Key? key,
    required UserRepository userRepository,
    required CategoryRepository categoryRepository,
  })  : _userRepository = userRepository,
        _categoryRepository = categoryRepository,
        super(key: key);

  @override
  _AddBudgetPageState createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List _loop = ['By Daily', 'By Weekly', 'Monthly', 'Annually', 'Custom'];
  String _loopSelected = 'By Daily';
  Map? _catrgory = null;
  late Map _walletSelected = Map<String, dynamic>();
  DateTime _selectedStartDate = new DateTime.now();
  DateTime _selectedEndDate = new DateTime.now();

  @override
  void initState() {
    super.initState();
    getWallet();
  }

  void getWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('WALLET');
    Map<String, dynamic> userMap =
        jsonDecode(userPref!) as Map<String, dynamic>;
    setState(() {
      _walletSelected = userMap;
    });
  }

  Future<Null> _selectDate(BuildContext context, bool check) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: check == true ? _selectedStartDate : _selectedEndDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyle.blueColor, // header background color
              onPrimary: AppStyle.lighTextColor, // header text color
              onSurface: AppStyle.textColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  primary: Colors.red,
                  textStyle: TextStyle(fontSize: 14.sp) // button text color
                  ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null &&
        picked != (check == true ? _selectedStartDate : _selectedEndDate))
      setState(() {
        if (check == true) {
          _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
        _loopSelected = 'Custom';
      });
  }

  _getDate(DateTime selectedDate) {
    return DateFormat.yMMMEd().format(selectedDate);
  }

  Future _selectWallet(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<QuerySnapshot>(
              future: _userRepository.getListWalletSnapshot(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    // final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    final List storedocs = [];
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map a = document.data() as Map<String, dynamic>;
                      storedocs.add(a);
                      a['id'] = document.id;
                    }).toList();
                    return OptionContainer(
                      padding: EdgeInsets.zero,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: storedocs.length,
                        itemBuilder: (context, index) {
                          return OptionContainer(
                            padding: EdgeInsets.zero,
                            // margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage(storedocs[index]['img']),
                                radius: 20.0,
                              ),
                              trailing: _walletSelected['name'] ==
                                      storedocs[index]['name']
                                  ? Icon(
                                      Icons.check_circle,
                                      color: AppStyle.blueColor,
                                    )
                                  : null,
                              title: Text(
                                storedocs[index]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              subtitle: Text(
                                "${storedocs[index]['remain']} ${storedocs[index]['currency']}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _walletSelected = storedocs[index];
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('no data');
                }
                return OptionContainer(
                    child: Center(child: CircularProgressIndicator()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: AppStyle.mainBorder,
                child: MaterialButton(
                  minWidth: double.infinity,
                  color: AppStyle.blueColor,
                  elevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Cancel",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Add Budget",
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
            child: Column(
              children: [
                OptionContainer(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Money",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppStyle.backgroundColor,
                                  borderRadius: AppStyle.mainBorder,
                                  // border: Border.all(color: AppStyle.textColor),
                                ),
                                child: Center(
                                  child: Text(
                                    "VNĐ",
                                    style: TextStyle(
                                      fontSize: 26.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  controller: _moneyController,
                                  inputFormatters: [CurrencyTextFormatter()],
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    color: AppStyle.textColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "0",
                                    hintStyle: TextStyle(fontSize: 26),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: AppStyle.hintTextColor,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: AppStyle.blueColor,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty || value == null) {
                                      return "Please input balance";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                OptionContainer(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppStyle.mainPadding),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.request_quote,
                                size: 32.sp,
                                color: AppStyle.hintTextColor,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _nameController,
                                style: TextStyle(
                                  color: AppStyle.textColor,
                                  fontSize: 26,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                    color: AppStyle.hintTextColor,
                                    fontSize: 25.sp,
                                  ),
                                ),
                                onTap: () {
                                  print("tap");
                                },
                                validator: (value) {
                                  if (value!.isEmpty || value == null) {
                                    return "Please input name of budget";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      //chọn category
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            _catrgory = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CategoryPage(
                                categoryRepository: _categoryRepository,
                                userRepository: _userRepository,
                              );
                            }));
                            if (_catrgory != null) {
                              setState(() {});
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  padding: EdgeInsets.only(right: 16),
                                  child: Image.asset(
                                    _catrgory == null
                                        ? AppUI.logo
                                        : _catrgory!['img'],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: _catrgory == null
                                        ? AutoSizeText(
                                            "Select Category",
                                            style: TextStyle(
                                              fontSize: 25.sp,
                                              color: AppStyle.hintTextColor,
                                            ),
                                          )
                                        : AutoSizeText(
                                            _catrgory!['name'],
                                            style: TextStyle(
                                              fontSize: 25.sp,
                                              color: AppStyle.textColor,
                                            ),
                                          ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppStyle.textColor,
                                  size: 28.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _selectWallet(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 16.0),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        _walletSelected['img'] ?? AppUI.logo),
                                    radius: 16.sp,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: AutoSizeText(
                                      _walletSelected['name'] ?? "",
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 25.sp,
                                        color: AppStyle.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 28.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Chọn date
                      Divider(),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _selectLoop(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.loop,
                                    size: 32.sp,
                                    color: AppStyle.hintTextColor,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: AutoSizeText(
                                      _loopSelected,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 25.sp,
                                        color: AppStyle.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 28.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.event,
                                size: 32.sp,
                                color: AppStyle.hintTextColor,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("From date"),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _selectDate(context, true),
                                      child: AutoSizeText(
                                        _getDate(_selectedStartDate),
                                        style: TextStyle(fontSize: 25.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.event,
                                size: 32.sp,
                                color: AppStyle.hintTextColor,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("End date"),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _selectDate(context, false),
                                      child: AutoSizeText(
                                        _getDate(_selectedEndDate),
                                        style: TextStyle(fontSize: 25.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: AppStyle.mainBorder,
                    child: MaterialButton(
                      minWidth: double.infinity,
                      color: AppStyle.blueColor,
                      elevation: 0,
                      onPressed: () async {
                        if (_catrgory == null) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) =>
                              createSnackBar(
                                  "You need to select category", context));
                        }
                        if (_formKey.currentState!.validate() &&
                            _catrgory != null) {
                          num tong =
                              await _userRepository.calculatorRemainBudget(
                                  _walletSelected['id'],
                                  _selectedStartDate,
                                  _selectedEndDate,
                                  _catrgory!['id']);
                          await _userRepository.insertBudget(
                              _nameController.text,
                              _moneyController.text,
                              "VNĐ",
                              _catrgory!['id'],
                              _walletSelected['id'],
                              _selectedStartDate,
                              _selectedEndDate,
                              tong);
                          WidgetsBinding.instance!.addPostFrameCallback((_) =>
                              createSnackBar("Add succesfully", context));
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "SAVE",
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
      ),
    );
  }

  Future _selectLoop(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context1) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppStyle.lightColor,
                borderRadius: AppStyle.mainBorder,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _loop.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_loop[index]),
                    trailing: _loop[index] == _loopSelected
                        ? Icon(
                            Icons.check_circle,
                            color: AppStyle.blueColor,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _loopSelected = _loop[index];
                        switch (_loop[index]) {
                          case 'By Daily':
                            _selectedStartDate = new DateTime.now();
                            _selectedEndDate = _selectedStartDate;
                            break;
                          case 'By Weekly':
                            _selectedStartDate = new DateTime.now();
                            _selectedEndDate =
                                _selectedStartDate.add(Duration(days: 6));
                            break;
                          case 'Monthly':
                            _selectedStartDate = new DateTime(
                                DateTime.now().year, DateTime.now().month, 1);
                            // int lastday = DateTime(now.year, now.month + 1, 0).day;
                            _selectedEndDate = new DateTime(DateTime.now().year,
                                DateTime.now().month + 1, 0);
                            break;
                          case 'Annually':
                            _selectedStartDate = new DateTime(
                                DateTime.now().year, DateTime.january, 1);
                            // int lastday = DateTime(now.year, now.month + 1, 0).day;
                            _selectedEndDate = new DateTime(
                                DateTime.now().year, DateTime.december, 31);
                            break;
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: AppStyle.mainBorder,
                child: MaterialButton(
                  minWidth: double.infinity,
                  color: AppStyle.blueColor,
                  elevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Cancel",
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
    );
  }
}
