// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:loda_app/src/widgets/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategoryPage extends StatefulWidget {
  Map? _category;
  final CategoryRepository _categoryRepository;
  AddCategoryPage(
      {Key? key, Map? category, required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        _category = category,
        super(key: key);

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  Map? get _category => widget._category;
  final _formKey = GlobalKey<FormState>();

  String path = AppUI.logo;
  late bool _isSelected = true;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_category != null) {
      path = _category!['img'];
      _nameController.text = _category!['name'];
      _isSelected = _category!['type'] == 0 ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: GeneralAppbar(
        "Create a new category",
        AppBarBtn(
            onPressed: () {
              Navigator.pop(context);
            },
            isAlign: true,
            icon: Icons.arrow_back),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 4),
          child: Container(
            height: 45.h,
            width: 45.w,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyle.mainPadding),
        child: Form(
          key: _formKey,
          child: Container(
            height: double.infinity,
            child: Column(
              children: [
                OptionContainer(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            child: CircleAvatar(
                              backgroundImage: AssetImage(path),
                              radius: 36,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppStyle.mainPadding),
                              child: TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  color: AppStyle.textColor,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Category name",
                                  hintStyle: TextStyle(fontSize: 22),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: AppStyle.blueColor,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || value == null) {
                                    return "Please enter name of category!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppStyle.backgroundColor,
                            borderRadius: AppStyle.mainBorder,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isSelected = true;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: _isSelected
                                            ? AppStyle.lightColor
                                            : AppStyle.backgroundColor,
                                        borderRadius: AppStyle.mainBorder,
                                      ),
                                      child: Text(
                                        "Expense",
                                        style: TextStyle(
                                            color: _isSelected
                                                ? AppStyle.blueColor
                                                : AppStyle.textColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isSelected = false;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: _isSelected
                                            ? AppStyle.backgroundColor
                                            : AppStyle.lightColor,
                                        borderRadius: AppStyle.mainBorder,
                                      ),
                                      child: Text(
                                        "Income",
                                        style: TextStyle(
                                            color: _isSelected
                                                ? AppStyle.textColor
                                                : AppStyle.blueColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                CategoryList(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: AppStyle.mainBorder,
                    child: MaterialButton(
                      minWidth: double.infinity,
                      color: AppStyle.blueColor,
                      elevation: 0,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_category == null) {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            final id = preferences.getString("IDCURRENT")!;
                            _categoryRepository.addCategory(
                                _nameController.text,
                                path,
                                id,
                                _isSelected ? 0 : 1);
                            WidgetsBinding.instance!.addPostFrameCallback((_) =>
                                createSnackBar("Add succesfully", context));
                          } else {
                            if (_category!['type'] == (_isSelected ? 0 : 1)) {
                              _categoryRepository.updateCategory(
                                  _nameController.text,
                                  path,
                                  _isSelected ? 0 : 1,
                                  _category!['id']);
                            }
                            WidgetsBinding.instance!.addPostFrameCallback((_) =>
                                createSnackBar("Update succesfully", context));
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          _category == null ? "Create a Category" : "Save",
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

  Expanded CategoryList() {
    return Expanded(
      child: Padding(
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
      ),
    );
  }
}
