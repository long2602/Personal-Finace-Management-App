import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';

class DataSettingPage extends StatefulWidget {
  const DataSettingPage({Key? key}) : super(key: key);

  @override
  _DataSettingPageState createState() => _DataSettingPageState();
}

class _DataSettingPageState extends State<DataSettingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  DateTime _selectedStartDate = new DateTime.now();
  DateTime _selectedEndDate = new DateTime.now();
  DateTimeRange? dateRange;
  final _dates = ['Yesterday', 'Today', 'Select day'];
  final _week = ['This week', 'Last week'];
  final _months = ['This month', 'Last month', 'Select month'];
  final _quarters = ['Quarter I', 'Quarter II', 'Quarter III', 'Quarter IV'];
  // final _customs = ['From date', 'To date'];
  _getDate(DateTime _selectedDate) {
    return DateFormat.yMMMEd().format(_selectedDate);
  }

  Future<Null> _selectDate(BuildContext context, DateTime _selectedDate) async {
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      Map<String, dynamic> map = {'title': 'Select day', 'date': _selectedDate};
      Navigator.pop(context, map);
    }
  }

  Future<Null> _selectMonth(BuildContext context) async {
    var month;
    final int? picked = await showDialog(
      context: context,
      builder: (BuildContext context1) => AlertDialog(
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: 12,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Center(child: Text("${index + 1}")),
                      selected:
                          DateTime.now().month == (index + 1) ? true : false,
                      onTap: () {
                        Navigator.pop(context, (index + 1));
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    if (picked != null) {
      setState(() {
        month = picked;
      });
      Map<String, dynamic> map = {'title': 'Select month', 'date': month};
      Navigator.pop(context, map);
    }
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 23)),
    );

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyle.blueColor, // header background color
              onPrimary: AppStyle.lighTextColor, // header text color
              onSurface: AppStyle.textColor, // body text color
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(),
              bodyText2: TextStyle(),
            ).apply(
              bodyColor: AppStyle.textColor,
              displayColor: AppStyle.blueColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
    });
    Map<String, dynamic> map = {
      'title': 'Custom',
      'dateS': dateRange!.start,
      'dateE': dateRange!.end
    };
    Navigator.pop(context, map);
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
                  child: Text(
                    "Data setting",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppStyle.textColor,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 45,
              ),
            ],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          indicator: BoxDecoration(
            color: AppStyle.lightColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          labelColor: AppStyle.textColor,
          tabs: [
            Tab(
              child: Align(
                child: Text(
                  "Date",
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.center,
              ),
            ),
            Tab(
              child: Align(
                child: Text(
                  "Week",
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.center,
              ),
            ),
            Tab(
              child: Align(
                child: Text(
                  "Month",
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.center,
              ),
            ),
            Tab(
              child: Align(
                child: Text(
                  "Quarter",
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.center,
              ),
            ),
            Tab(
              child: Align(
                child: Text(
                  "Custom",
                  style: TextStyle(fontSize: 16),
                ),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppStyle.mainPadding, vertical: 20),
        child: TabBarView(
          controller: _tabController,
          children: [
            ListView.builder(
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_dates[index]),
                  onTap: () {
                    Map<String, dynamic> map;
                    switch (index) {
                      case 0:
                        map = {
                          'title': _dates[index],
                          'date': DateTime.now().subtract(Duration(days: 1))
                        };
                        Navigator.pop(context, map);
                        break;
                      case 1:
                        map = {'title': _dates[index], 'date': DateTime.now()};
                        Navigator.pop(context, map);
                        break;
                      case 2:
                        _selectDate(context, _selectedStartDate);
                        break;
                    }
                  },
                );
              },
            ),
            ListView.builder(
                itemCount: _week.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_week[index]),
                    onTap: () {
                      Map<String, dynamic> map;
                      switch (index) {
                        case 0:
                          _selectedStartDate = DateTime.now().subtract(
                              Duration(days: DateTime.now().weekday - 1));
                          _selectedEndDate = DateTime.now().add(Duration(
                              days: DateTime.daysPerWeek -
                                  DateTime.now().weekday));
                          map = {
                            'title': _week[index],
                            'dateS': _selectedStartDate,
                            'dateE': _selectedEndDate,
                          };
                          Navigator.pop(context, map);
                          break;
                        case 1:
                          _selectedStartDate = DateTime.now()
                              .subtract(
                                  Duration(days: DateTime.now().weekday - 1))
                              .subtract(Duration(days: 7));
                          _selectedEndDate = DateTime.now()
                              .add(Duration(
                                  days: DateTime.daysPerWeek -
                                      DateTime.now().weekday))
                              .subtract(Duration(days: 7));
                          map = {
                            'title': _week[index],
                            'dateS': _selectedStartDate,
                            'dateE': _selectedEndDate,
                          };
                          Navigator.pop(context, map);
                          break;
                      }
                    },
                  );
                }),
            ListView.builder(
                itemCount: _months.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_months[index]),
                    onTap: () {
                      Map<String, dynamic> map;
                      switch (index) {
                        case 0:
                          map = {
                            'title': _months[index],
                            'date': DateTime.now().month
                          };
                          Navigator.pop(context, map);
                          break;
                        case 1:
                          map = {
                            'title': _months[index],
                            'date': DateTime.now()
                                .subtract(Duration(days: 30))
                                .month
                          };
                          Navigator.pop(context, map);
                          break;
                        case 2:
                          _selectMonth(context);
                          break;
                      }
                    },
                  );
                }),
            ListView.builder(
                itemCount: _quarters.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_quarters[index]),
                    onTap: () {
                      Map<String, dynamic> map;
                      switch (index) {
                        case 0:
                          map = {
                            'title': 'Quarter',
                            'date': _quarters[index],
                          };
                          Navigator.pop(context, map);
                          break;
                        case 1:
                          map = {
                            'title': 'Quarter',
                            'date': _quarters[index],
                          };
                          Navigator.pop(context, map);
                          break;
                        case 2:
                          map = {
                            'title': 'Quarter',
                            'date': _quarters[index],
                          };
                          Navigator.pop(context, map);
                          break;
                        case 3:
                          map = {
                            'title': 'Quarter',
                            'date': _quarters[index],
                          };
                          Navigator.pop(context, map);
                          break;
                      }
                    },
                  );
                }),
            Column(
              children: [
                ListTile(
                  title: Text(
                    'From date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(_getDate(_selectedStartDate)),
                  onTap: () {
                    pickDateRange(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'To date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(_getDate(_selectedEndDate)),
                  onTap: () {
                    pickDateRange(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
