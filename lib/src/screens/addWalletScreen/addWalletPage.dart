// ignore_for_file: non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:loda_app/src/widgets/snackBar.dart';
import 'package:loda_app/src/widgets/text_input_formater.dart';

class AddWalletPage extends StatefulWidget {
  Map? _wallet;
  final UserRepository _userRepository;
  AddWalletPage({
    Key? key,
    Map? wallet,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        _wallet = wallet,
        super(key: key);
  @override
  _AddWalletPageState createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  UserRepository get _userRepository => widget._userRepository;
  Map? get _wallet => widget._wallet;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String path = AppUI.logo;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (_wallet != null) {
      _nameController.text = _wallet!['name'];
      _moneyController.text = textToCurrency(_wallet!['remain'].toString());
      _noteController.text = _wallet!['note'];
      path = _wallet!['img'];
    }
  }

  Future _selectImg(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: AppStyle.backgroundColor,
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => CategoryList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Add Wallet",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 15),
          child: SizedBox(
            width: 45.w,
          ),
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.asset(AppUI.wallet2x),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: AutoSizeText(
                          "Initial Balance",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
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
                                    _wallet == null
                                        ? 'VNĐ'
                                        : _wallet!['currency'],
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
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [CurrencyTextFormatter()],
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    color: AppStyle.textColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '0',
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
                      ),
                    ],
                  ),
                ),
                OptionContainer(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppStyle.mainPadding),
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _selectImg(context),
                                splashColor: AppStyle.blueColor,
                                borderRadius: AppStyle.mainBorder,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(path),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: AppStyle.textColor,
                                fontSize: 26,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Name',
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
                                  return "Please input name";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.text_snippet,
                              size: 40.sp,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _noteController,
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                color: AppStyle.textColor,
                                fontSize: 26,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Wtrite ...',
                                hintStyle: TextStyle(
                                  color: AppStyle.hintTextColor,
                                  fontSize: 25.sp,
                                ),
                              ),
                              onTap: () {
                                print("tap");
                              },
                            ),
                          ),
                        ],
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_wallet == null) {
                            _userRepository.insertWallet(
                                _nameController.text,
                                _moneyController.text,
                                _noteController.text,
                                "VNĐ",
                                path);
                            WidgetsBinding.instance!.addPostFrameCallback((_) =>
                                createSnackBar("Add successfully", context));
                            Navigator.pop(context);
                          } else {
                            final temp = currencyToInt(_moneyController.text) -
                                _wallet!['balance'];
                            final newRemain = _wallet!['remain'] + temp;
                            _userRepository.updateWallet(
                              _wallet!['id'],
                              _nameController.text,
                              path,
                              _moneyController.text,
                              _noteController.text,
                              'VNĐ',
                              newRemain,
                            );
                            WidgetsBinding.instance!.addPostFrameCallback((_) =>
                                createSnackBar(
                                    "Updated successfully", context));
                          }
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

  Widget CategoryList() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyle.mainPadding),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppStyle.lightColor,
          borderRadius: AppStyle.mainBorder,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: GridView.builder(
            itemCount: AppUI.imgs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      path = AppUI.imgs[index];
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(AppUI.imgs[index]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
