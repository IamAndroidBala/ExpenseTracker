import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/controllers/add_category_controller.dart';
import 'package:flutter_expense_tracker_app/controllers/chart_controller.dart';
import 'package:flutter_expense_tracker_app/views/widgets/report_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/theme_controller.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  final List<String> _transactionTypes = ['Income', 'Expense'];
  final _homeController = Get.find<HomeController>();
  final _chartController = Get.put(ChartController());
  final AddCategoryController _addCategoryController = Get.put(AddCategoryController());
  final _themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body:_addItems()
    );
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  ListView _addItems () {
   return ListView.builder(
      itemCount: _addCategoryController.myCategories.length,
      itemBuilder: (context, i) {
        final category = _addCategoryController.myCategories[i].type!;
        final budget = _addCategoryController.myCategories[i].budget!;
        final spent = _homeController.amountSpentForCategory(category, _chartController.transactionType);
        return ReportTile(category: category, budgetLimit: budget, spentAmount: spent);
      },
    );
  }
  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'Budget Report',
        style: TextStyle(color: _themeController.color),
      ),
      leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: _themeController.color)
      ),
      actions: _homeController.myTransactions.isEmpty
          ? []
          : [
        Row(
          children: [
            Text(_chartController.transactionType.isEmpty ? _transactionTypes[0] : _chartController.transactionType,
              style: TextStyle(
                fontSize: 14.sp,
                color: _themeController.color,
              ),
            ),
            SizedBox(
              width: 40,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                    customButton: Icon(
                      Icons.keyboard_arrow_down,
                      color: _themeController.color,
                    ),
                    items: _transactionTypes
                        .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                      ),
                    ),
                    ).toList(),
                    onChanged: (val) {
                      setState(() {
                       _addItems();
                      });
                      _chartController.changeTransactionType((val as String));
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.redAccent,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.yellow,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      padding: null,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.redAccent,
                      ),
                      elevation: 8,
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    )
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

