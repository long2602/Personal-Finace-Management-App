import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/categoryScreen/categoryPage.dart';

import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/snackBar.dart';
import 'package:loda_app/src/widgets/text_input_formater.dart';
import 'package:path/path.dart' as Path;

class ViewTransactionPage extends StatefulWidget {
  final Map _transaction;
  final UserRepository _userRepository;
  final Map _wallet;
  final CategoryRepository _categoryRepository;
  const ViewTransactionPage(
      {Key? key,
      required Map transaction,
      required UserRepository userRepository,
      required Map wallet,
      required CategoryRepository categoryRepository})
      : _transaction = transaction,
        _userRepository = userRepository,
        _wallet = wallet,
        _categoryRepository = categoryRepository,
        super(key: key);

  @override
  _ViewTransactionPageState createState() => _ViewTransactionPageState();
}

class _ViewTransactionPageState extends State<ViewTransactionPage> {
  Map get _transaction => widget._transaction;
  UserRepository get _userRepository => widget._userRepository;
  CategoryRepository get _categoryRepository => widget._categoryRepository;

  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _selectedDate = new DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _img = "";
  String _currency = "";
  File? imgPath;
  String imgUrl = "";
  bool _Visible = false;
  Map get _wallet => widget._wallet;
  Map _walletSelected = new Map<String, dynamic>();
  Map? _catrgory = null;
  bool _edited = false;
  String dropdownValue = 'Add Expense';
  bool _type = true;
  bool _checkType = true;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
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
        });
    if (time != null && time != _selectedTime) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  _getDate() {
    return DateFormat.yMMMEd().format(_selectedDate);
  }

  _getTime() {
    TimeOfDay time = _selectedTime;
    return "${time.hour}:${time.minute}";
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);

      // final imgPermanent = await saveImage(image.path);
      setState(() {
        this.imgPath = imageTemporary;
      });
      print(imgPath!.path);
    } on PlatformException catch (e) {
      print('failed to pick image: $e');
    }
  }

  Future uploadImage() async {
    if (imgPath == null) return;
    final filename = Path.basename(imgPath!.path);
    final destination = filename;
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      final task = ref.putFile(imgPath!);
      final snapshot = await task.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      setState(() {
        imgUrl = url;
      });
    } on FirebaseException catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _moneyController.text = textToCurrency(_transaction['money'].toString());
    _noteController.text = _transaction['description'];
    _eventController.text = _transaction['event'];
    _locationController.text = _transaction['location'];
    _img = _transaction['img'];
    _currency = _transaction['currency'];
    _type = _transaction['type'];
    _checkType = _type;
    if (_type == true)
      dropdownValue = 'Add Expense';
    else
      dropdownValue = 'Add Income';
    DateTime dt = (_transaction['createAt'] as Timestamp).toDate();
    _selectedDate = new DateTime(dt.year, dt.month, dt.day);
    _selectedTime = new TimeOfDay(hour: dt.hour, minute: dt.minute);
    _walletSelected = _wallet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: AppStyle.backgroundColor,
        title: Container(
          width: double.infinity,
          // height: 60,
          decoration: BoxDecoration(color: AppStyle.backgroundColor),
          child: Row(
            children: [
              AppBarBtn(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  isAlign: true,
                  icon: Icons.arrow_back),
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 45.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          decoration: BoxDecoration(
                            color: AppStyle.lightColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.r),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: FaIcon(
                                FontAwesomeIcons.caretDown,
                                color: AppStyle.textColor,
                              ),
                              iconSize: 26.sp,
                              style: TextStyle(
                                color: AppStyle.textColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  if (dropdownValue == "Add Expense")
                                    _type = true;
                                  else
                                    _type = false;
                                });
                              },
                              items: <String>[
                                'Add Expense',
                                'Add Income'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(value),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppBarBtn(
                  onPressed: () {
                    setState(() {
                      if (_edited == true) {
                        _edited = false;
                        WidgetsBinding.instance!.addPostFrameCallback(
                            (_) => createSnackBar("Close Edit Mode", context));
                      } else {
                        _edited = true;
                        WidgetsBinding.instance!.addPostFrameCallback(
                            (_) => createSnackBar("Open Edit Mode", context));
                      }
                    });
                  },
                  isAlign: false,
                  icon: Icons.edit)
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyle.mainPadding, vertical: AppStyle.mainPadding),
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
                                  _currency,
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: TextField(
                                onTap: () {
                                  if (_edited == false) {
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) =>
                                            createSnackBar(
                                                "You need to open edit mode",
                                                context));
                                  }
                                },
                                controller: _moneyController,
                                enabled: _edited,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  color: AppStyle.textColor,
                                ),
                                inputFormatters: [CurrencyTextFormatter()],
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
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //phần nhập thông tin ví cơ bản
              OptionContainer(
                width: double.infinity,
                padding: EdgeInsets.all(AppStyle.mainPadding),
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    //chọn category
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (_edited == true) {
                            _catrgory = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CategoryPage(
                                categoryRepository: _categoryRepository,
                                userRepository: _userRepository,
                              );
                            }));
                            if (_catrgory != null) {
                              setState(() {
                                _type = _catrgory!['type'] == 0 ? true : false;
                                if (_type == true)
                                  dropdownValue = "Add Expense";
                                else
                                  dropdownValue = "Add Income";
                              });
                            }
                          } else {
                            WidgetsBinding.instance!.addPostFrameCallback((_) =>
                                createSnackBar(
                                    "You need to open edit mode", context));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                height: 45,
                                padding: EdgeInsets.only(right: 16),
                                child: Image.asset(_catrgory != null
                                    ? _catrgory!['img']
                                    : _transaction['imgCategory']),
                              ),
                              Expanded(
                                child: Container(
                                  child: _catrgory != null
                                      ? AutoSizeText(
                                          _catrgory!['name'],
                                          style: TextStyle(
                                            fontSize: 25.sp,
                                            color: AppStyle.textColor,
                                          ),
                                        )
                                      : AutoSizeText(
                                          _transaction['nameCategory'],
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
                    //Description
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.text_snippet,
                              size: 32.sp,
                              color: AppStyle.hintTextColor,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _noteController,
                              enabled: _edited,
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                color: AppStyle.textColor,
                                fontSize: 26,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Note",
                                hintStyle: TextStyle(
                                  color: AppStyle.hintTextColor,
                                  fontSize: 25.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    //Chọn date
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (_edited == true) {
                                        _selectDate(context);
                                      } else {
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) =>
                                                createSnackBar(
                                                    "You need to open edit mode",
                                                    context));
                                      }
                                    },
                                    child: AutoSizeText(
                                      _getDate(),
                                      style: TextStyle(fontSize: 25.sp),
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (_edited == true) {
                                        _selectTime(context);
                                      } else {
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) =>
                                                createSnackBar(
                                                    "You need to open edit mode",
                                                    context));
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: AutoSizeText(
                                        _getTime(),
                                        style: TextStyle(fontSize: 25.sp),
                                      ),
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
                    //Chọn ví
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (_edited == true) {
                            _selectWallet(context);
                          } else {
                            WidgetsBinding.instance!.addPostFrameCallback((_) =>
                                createSnackBar(
                                    "You need to open edit mode", context));
                          }
                        },
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
                  ],
                ),
              ),
              //btn
              Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ClipRRect(
                    borderRadius: AppStyle.mainBorder,
                    child: MaterialButton(
                      minWidth: double.infinity,
                      color: AppStyle.lightColor,
                      elevation: 0,
                      onPressed: () {
                        setState(() {
                          _Visible = !_Visible;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "More Details",
                              style: TextStyle(
                                fontSize: 20.sp,
                              ),
                            ),
                            Icon(
                              !_Visible ? Icons.expand_more : Icons.expand_less,
                              size: 28.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _Visible,
                child: OptionContainer(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (_edited == false) {
                              WidgetsBinding.instance!.addPostFrameCallback(
                                  (_) => createSnackBar(
                                      "You need to open edit mode", context));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.bungalow,
                                    size: 32.sp,
                                    color: AppStyle.hintTextColor,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _eventController,
                                    enabled: _edited,
                                    style: TextStyle(
                                      color: AppStyle.textColor,
                                      fontSize: 26,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Event",
                                      hintStyle: TextStyle(
                                        color: AppStyle.hintTextColor,
                                        fontSize: 25.sp,
                                      ),
                                    ),
                                  ),
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
                          onTap: () {
                            if (_edited == false) {
                              WidgetsBinding.instance!.addPostFrameCallback(
                                  (_) => createSnackBar(
                                      "You need to open edit mode", context));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.place,
                                    size: 32.sp,
                                    color: AppStyle.hintTextColor,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _locationController,
                                    enabled: _edited,
                                    style: TextStyle(
                                      color: AppStyle.textColor,
                                      fontSize: 26,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Location",
                                      hintStyle: TextStyle(
                                        color: AppStyle.hintTextColor,
                                        fontSize: 25.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (imgPath == null && _img.isEmpty)
                            ? Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: ClipRRect(
                                      borderRadius: AppStyle.mainBorder,
                                      child: MaterialButton(
                                        height: 120,
                                        color: AppStyle.blueColor,
                                        onPressed: () {
                                          if (_edited == true) {
                                            pickImage(ImageSource.camera);
                                            setState(() {});
                                          } else {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) =>
                                                    createSnackBar(
                                                        "You need to open edit mode",
                                                        context));
                                          }
                                        },
                                        child: Icon(
                                          Icons.photo_camera,
                                          color: AppStyle.lightColor,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: ClipRRect(
                                      borderRadius: AppStyle.mainBorder,
                                      child: MaterialButton(
                                        height: 120,
                                        color: AppStyle.blueColor,
                                        onPressed: () {
                                          if (_edited == true) {
                                            pickImage(ImageSource.gallery);
                                            setState(() {});
                                          } else {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) =>
                                                    createSnackBar(
                                                        "You need to open edit mode",
                                                        context));
                                          }
                                        },
                                        child: Icon(
                                          Icons.image,
                                          size: 30,
                                          color: AppStyle.lightColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ((imgPath == null && _img.isNotEmpty)
                                ? Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Image.network(_img),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            if (_edited == true) {
                                              setState(() {
                                                imgPath = null;
                                                _img = "";
                                              });
                                            } else {
                                              WidgetsBinding.instance!
                                                  .addPostFrameCallback((_) =>
                                                      createSnackBar(
                                                          "You need to open edit mode",
                                                          context));
                                            }
                                          },
                                          icon: Icon(Icons.cancel_sharp),
                                          color: Colors.red,
                                          iconSize: 36.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Image.file(imgPath!),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              imgPath = null;
                                            });
                                          },
                                          icon: Icon(Icons.cancel_sharp),
                                          color: Colors.red,
                                          iconSize: 36.sp,
                                        ),
                                      ),
                                    ],
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _edited,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: AppStyle.mainBorder,
                    child: MaterialButton(
                      minWidth: double.infinity,
                      color: AppStyle.blueColor,
                      elevation: 0,
                      onPressed: () async {
                        if (_wallet['id'] == _walletSelected['id']) {
                          if (imgPath != null) {
                            await uploadImage();
                          }
                          updateTransaction(
                              _moneyController.text,
                              _noteController.text,
                              _walletSelected['id'],
                              _catrgory == null
                                  ? _transaction['idCategory']
                                  : _catrgory!['id'],
                              _selectedDate,
                              _selectedTime,
                              _eventController.text,
                              _locationController.text,
                              imgUrl,
                              _type,
                              _catrgory == null
                                  ? _transaction['nameCategory']
                                  : _catrgory!['name'],
                              _catrgory == null
                                  ? _transaction['imgCategory']
                                  : _catrgory!['img'],
                              "VNĐ",
                              _walletSelected['balance'],
                              _transaction['id'],
                              _checkType,
                              _transaction['money']);
                        } else {
                          print("khac");
                        }
                        Navigator.pop(context);
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
              ),
            ],
          ),
        ),
      ),
    );
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

  void updateTransaction(
      String money,
      String note,
      String idwallet,
      String idcategory,
      DateTime dateTime,
      TimeOfDay timeOfDay,
      String event,
      String location,
      String img,
      bool type,
      String namewallet,
      String imgwallet,
      String currency,
      num total,
      String idtransaction,
      bool checktype,
      num oldmoney) {
    DateTime createAt = new DateTime(dateTime.year, dateTime.month,
        dateTime.day, timeOfDay.hour, timeOfDay.minute);
    _userRepository.updateTransaction(money, note, idwallet, idcategory,
        createAt, event, location, img, type, currency, idtransaction);
    _userRepository.calculateWallet2(idwallet, total);
    num old = currencyToInt(money) - oldmoney;
    old > 0
        ? _userRepository.remainBudget(
            idcategory, old.toString(), dateTime, true)
        : _userRepository.remainBudget(
            idcategory, old.toString(), dateTime, false);
  }
}
