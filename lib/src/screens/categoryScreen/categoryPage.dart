import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbols.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/models/category.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/addCategoryScreen/addCategoryPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPage extends StatefulWidget {
  final CategoryRepository _categoryRepository;
  final UserRepository _userRepository;

  const CategoryPage({
    Key? key,
    required CategoryRepository categoryRepository,
    required UserRepository userRepository,
  })  : _categoryRepository = categoryRepository,
        _userRepository = userRepository,
        super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  UserRepository get _userRepository => widget._userRepository;

  late TabController _tabController;
  late String id;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchData();
  }

  fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString("IDCURRENT")!;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppStyle.lightColor,
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
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 15),
                  child: Container(
                    height: 45.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                      color: AppStyle.lightColor,
                      borderRadius: AppStyle.mainBorder,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: AppStyle.blueColor,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      "Select category",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppStyle.textColor,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 4),
                  child: Container(
                    height: 45.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                      color: AppStyle.lightColor,
                      borderRadius: AppStyle.mainBorder,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCategoryPage(
                                        categoryRepository: _categoryRepository,
                                      )));
                        },
                        icon: Icon(
                          Icons.add,
                          color: AppStyle.blueColor,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(
              color: AppStyle.lightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            labelColor: AppStyle.textColor,
            tabs: [
              Tab(
                child: Align(
                  child: Text(
                    "Expense",
                    style: TextStyle(fontSize: 16),
                  ),
                  alignment: Alignment.center,
                ),
              ),
              Tab(
                child: Align(
                  child: Text(
                    "Income",
                    style: TextStyle(fontSize: 16),
                  ),
                  alignment: Alignment.center,
                ),
              ),
              Tab(
                child: Align(
                  child: Text(
                    "Your",
                    style: TextStyle(fontSize: 16),
                  ),
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: _categoryRepository.getCategories(),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppStyle.mainPadding),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      selectTransaction(
                          Category.CategoriesByType(storedocs, 0, id), true),
                      selectTransaction(
                          Category.CategoriesByType(storedocs, 1, id), true),
                      selectTransaction(
                          Category.CategoriesByStatus(storedocs, id), false),
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Text('no data');
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Padding selectTransaction(List categories, bool check) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          Expanded(
            child: categories.isEmpty
                ? Text("Don't have my category !!!")
                : (check == true
                    ? GridView.builder(
                        itemCount: categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          return itemCategory(categories[index]);
                        },
                      )
                    : ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return itemCustomCategory(
                              categories[index],
                              _categoryRepository,
                              () => _deleteDialog(
                                  context,
                                  categories[index]['id'],
                                  categories[index]['type']),
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddCategoryPage(
                                            categoryRepository:
                                                _categoryRepository,
                                            category: categories[index],
                                          ))));
                        })),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDialog(BuildContext context, String cid, int type) async {
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
                AppUI.warning2x,
                width: 100.w,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 22),
                child: Text(
                  "If you delete this category, all relevant records will leave category information blank. Are you sure you want delete it?",
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
                          onPressed: () => Navigator.pop(context1),
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
                            deleteCategory(cid, type);
                            Navigator.pop(context1);
                            setState(() {});
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

  void deleteCategory(String cid, int type) async {
    await Future.wait([
      _userRepository.deleteCategory(cid),
      _userRepository.deleteAllTransAndCategory(cid),
    ]);
  }
}

// ignore: camel_case_types
class itemCategory extends StatelessWidget {
  Map category;
  itemCategory(this.category);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(
            context,
            category,
          );
        },
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(category['img']),
              ),
              Center(
                child: AutoSizeText(
                  category['name'],
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class itemCustomCategory extends StatelessWidget {
  Map category;
  final CategoryRepository _categoryRepository;
  VoidCallback _onPressed;
  VoidCallback _onPressed2;
  itemCustomCategory(this.category, this._categoryRepository, this._onPressed,
      this._onPressed2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pop(
            context,
            category,
          );
        },
        leading: CircleAvatar(
          backgroundImage: AssetImage(category['img']),
          radius: 24.0,
        ),
        title: AutoSizeText(
          category['name'],
          maxLines: 2,
          style: TextStyle(fontSize: 18.sp),
        ),
        trailing: Wrap(
          children: [
            IconButton(
              onPressed: _onPressed2,
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: _onPressed,
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
