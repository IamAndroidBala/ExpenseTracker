import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/controllers/home_controller.dart';
import 'package:flutter_expense_tracker_app/controllers/theme_controller.dart';
import 'package:flutter_expense_tracker_app/views/screens/add_transaction_screen.dart';
import 'package:flutter_expense_tracker_app/views/screens/all_transactions_screen.dart';
import 'package:flutter_expense_tracker_app/views/screens/chart_screen.dart';
import 'package:flutter_expense_tracker_app/views/screens/report_screen.dart';
import 'package:flutter_expense_tracker_app/views/screens/settings_screen.dart';
import 'package:flutter_expense_tracker_app/views/widgets/budget_status_view.dart';
import 'package:flutter_expense_tracker_app/views/widgets/income_expense.dart';
import 'package:flutter_expense_tracker_app/views/widgets/placeholder_info.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../controllers/add_category_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../utils/colors.dart';
import '../../utils/common_methods.dart';
import '../../utils/theme.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController _homeController = Get.put(HomeController());
  final _addCategoryController = Get.put(AddCategoryController());
  final _settingsController = Get.put(SettingsController());
  final _themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      return Scaffold(
        appBar: _appBar(),
        drawer: Theme(
          data: Get.isDarkMode ? Theme.of(context).copyWith(canvasColor: darkModeScaffoldBgClr,)
              : Theme.of(context).copyWith(canvasColor: lightModeScaffoldBgCle,),
          child: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                DrawerHeader(
                    decoration: BoxDecoration(color: Get.isDarkMode? darkModeScaffoldBgClr: Colors.lightBlueAccent ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 25.r,
                          backgroundImage: FileImage(File(_settingsController.selectedImage)),
                        ),
                        Text(_settingsController.userName.isNotEmpty?_settingsController.userName:'Edit in settings' , style: Themes().headingTextStyle,maxLines: 1,),
                        Text(_settingsController.phone,style: Themes().subTitleStyle,maxLines: 1,),
                        Text(_settingsController.email,style: Themes().subTitleStyle,maxLines: 1,),
                      ],
                    )
                ),

                ListTile(
                  title: Text(
                    'All Transactions',
                    style: Themes().labelStyle,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => AllTransactionsScreen());
                  },
                ),

                ListTile(
                  title: Text(
                    'Chart',
                    style: Themes().labelStyle,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => ChartScreen());
                  },
                ),

                ListTile(
                  title: Text('Reports',
                    style: Themes().labelStyle,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(()=> ReportScreen());
                  },
                ),

                ListTile (
                  title: Text(
                    'DarkMode',
                    style: Themes().labelStyle,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _themeController.switchTheme();
                  },
                  trailing: IconButton(
                    onPressed: () async {
                      _themeController.switchTheme();
                    },
                    icon: Icon(Get.isDarkMode ? Icons.wb_sunny : Icons.nightlight),
                    color: _themeController.color,
                  ),
                ),

                ListTile(
                  title: Text(
                    'Settings',
                    style: Themes().labelStyle,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => SettingsScreen());
                  },
                ),

              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Balance',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: _themeController.color,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_homeController.selectedCurrency.symbol} ${_homeController.totalBalance.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Budget',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: _themeController.color,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_homeController.selectedCurrency.symbol} ${_homeController.totalBudget.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IncomeExpense(
                    isIncome: true,
                    symbol: _homeController.selectedCurrency.symbol,
                    amount: _homeController.totalIncome.value,
                  ),
                  IncomeExpense(
                    isIncome: false,
                    symbol: _homeController.selectedCurrency.symbol,
                    amount: _homeController.totalExpense.value,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01.h,
              ),
              _homeController.myTransactions.isEmpty
                  ? Container()
                  : Padding(padding: EdgeInsets.symmetric(vertical: 10.h,),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Center(
                              child: IconButton(
                                  onPressed: () => _showDatePicker(context),
                                  icon: Icon(
                                    Icons.calendar_month,
                                    color: _themeController.color,
                                  )
                              )
                          ),
                        ),
                        title: Text(
                          _homeController.selectedDate.day == DateTime.now().day ? 'Today'
                              : DateFormat.yMd().format(_homeController.selectedDate),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                           BudgetStatusView(),
                        ]
                        ),
                      ),
                    ),
              PlaceholderInfo(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () async {
            _addCategoryController.getCategories();
            _addCategoryController.getCashMode();
            _homeController.getTransactions();
             await Get.to(() => AddTransactionScreen());
          },
          child: Icon(
            Icons.add,
          ),
        ),
      );
    });
  }

  _showDatePicker(BuildContext context) async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2012),
        initialDate: DateTime.now(),
        lastDate: DateTime(2122));
    if (pickerDate != null) {
      _homeController.updateSelectedDate(pickerDate);
    }
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Expense Tracker'),
    );
  }
}
