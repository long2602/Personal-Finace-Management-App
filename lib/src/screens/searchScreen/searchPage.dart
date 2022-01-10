import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/searchScreen/optionSearchPage.dart';
import 'package:loda_app/src/screens/transactionScreen/viewTransaction/viewTransactionPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';

class SearchPage extends StatefulWidget {
  final UserRepository _userRepository;
  final Map _walletSelected;
  final CategoryRepository _categoryRepository;
  final List _categories;

  const SearchPage(
      {Key? key,
      required UserRepository userRepository,
      required Map walletSelected,
      required CategoryRepository categoryRepository,
      required List categories})
      : _userRepository = userRepository,
        _walletSelected = walletSelected,
        _categoryRepository = categoryRepository,
        _categories = categories,
        super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  UserRepository get _userRepository => widget._userRepository;
  Map get _walletSelected => widget._walletSelected;
  CategoryRepository get _categoryRepository => widget._categoryRepository;
  List get _categories => widget._categories;
  final TextEditingController _searchController = TextEditingController();
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var id = tripSnapshot['idCategory'].toString();
        var title;
        _categories.forEach((element) {
          if (id == element['id']) {
            title = element['name'].toString().toLowerCase();
            return;
          }
        });

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    var data = await _userRepository.getTransactions(_walletSelected['id']);
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
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
          child: Row(
            children: [
              AppBarBtn(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  isAlign: true,
                  icon: Icons.arrow_back),
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    fillColor: AppStyle.lightColor,
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Container(
                      width: 50.sp,
                      child: Icon(
                        Icons.search,
                        color: AppStyle.textColor,
                      ),
                    ),
                    hintText: "Enter ....",
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffEEEEEE), width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    ),
                  ),
                ),
              ),
              AppBarBtn(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OptionSearchPage(
                                  userRepository: _userRepository,
                                  categoryRepository: _categoryRepository,
                                  categories: _categories,
                                )));
                  },
                  isAlign: false,
                  icon: Icons.tune),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
          child: ListView.builder(
              itemCount: _resultsList.length,
              itemBuilder: (context, index) {
                Map element =
                    _resultsList[index].data() as Map<String, dynamic>;
                _categories.forEach((e) {
                  if (e['id'] == element['idCategory']) {
                    element['imgCategory'] = e['img'];
                    element['nameCategory'] = e['name'];
                  }
                });
                return OptionContainer(
                  margin: EdgeInsets.only(bottom: 4.0, top: 4.0),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ViewTransactionPage(
                          transaction: element,
                          userRepository: _userRepository,
                          wallet: _walletSelected,
                          categoryRepository: _categoryRepository,
                        );
                      }));
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(element['imgCategory']),
                      radius: 20.0,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          element['nameCategory'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          '${AppStyle.moneyFormat.format(element['money'])} ${element['currency']}',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: element['type'] == true
                                ? Color(0xffb57084)
                                : Color(0xff5985b5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
