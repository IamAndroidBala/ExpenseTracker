import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/utils/constants.dart';
import 'package:flutter_expense_tracker_app/views/screens/edit_personal_details.dart';
import 'package:flutter_expense_tracker_app/views/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _box = GetStorage();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => navigateToNextScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Text(
          "Expense Tracker",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: primaryColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  navigateToNextScreen() {
    if (_box.read(APP_INITIALISED) != null) {
      Get.off(() => HomeScreen());
    } else {
      Get.off(() => EditPersonalDetailsScreen(from: 'Splash',));
    }
  }

}
