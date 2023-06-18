import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class BudgetStatusView extends StatelessWidget {
  BudgetStatusView({Key? key}) : super(key: key);
  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    String budgetStatusText = _homeController.budgetStatus == false ? 'Status : Limit crossed': 'Status : Good';
    Color budgetStatusColor = _homeController.budgetStatus == false ? Colors.red : Colors.green;
    return Text(
      budgetStatusText,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: budgetStatusColor,
      ),
    );
  }
}
