import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/controllers/add_transaction_controller.dart';
import 'package:flutter_expense_tracker_app/controllers/home_controller.dart';
import 'package:flutter_expense_tracker_app/controllers/theme_controller.dart';
import 'package:flutter_expense_tracker_app/views/screens/edit_transaction_screen.dart';
import 'package:flutter_expense_tracker_app/views/widgets/transaction_tile.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllTransactionsScreen extends StatelessWidget {
  AllTransactionsScreen({Key? key}) : super(key: key);
  final HomeController _homeController = Get.find();
  final AddTransactionController _addTransactionController = Get.put(AddTransactionController());
  final ThemeController _themeController = Get.find();

  final List<String> _transactionTypes = ['Income', 'Expense'];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: _appBar(),
        body: ListView.builder(
          itemCount: _homeController.myTransactions.length,
          itemBuilder: (context, i) {
            final transaction = _homeController.myTransactions[i];
            final text = '${_homeController.selectedCurrency.symbol} ${transaction.amount}';

            if (transaction.type == _addTransactionController.transactionType) {
              final bool isIncome = transaction.type == 'Income' ? true : false;
              final formatAmount = isIncome ? '+ $text' : '- $text';
              return GestureDetector(
                onTap: () async {
                  await Get.to(() => EditTransactionScreen(tm: transaction));
                  _homeController.getTransactions();
                },
                child: TransactionTile(
                    transaction: transaction,
                    formatAmount: formatAmount,
                    isIncome: isIncome),
              );
            }
            return SizedBox();
          },
        ),
      );
    });
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'All Transactions',
        style: TextStyle(color: _themeController.color),
      ),
      leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: _themeController.color)),
      actions: [
        Row(
          children: [
            Text(
              _addTransactionController.transactionType.isEmpty
                  ? _transactionTypes[0]
                  : _addTransactionController.transactionType,
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
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    _addTransactionController.changeTransactionType((val as String));
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
