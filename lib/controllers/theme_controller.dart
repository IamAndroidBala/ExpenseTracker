import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/colors.dart';

class ThemeController extends GetxController {
  bool get _loadThemeFromBox => _box.read(_key) ?? false;
  final Rx<Color> _color = Colors.white.obs;
  final _box = GetStorage();
  final _key = 'isDarkMode';
  ThemeMode get theme => _loadThemeFromBox ? ThemeMode.dark : ThemeMode.light;
  Color get color => _color.value;

  @override
  void onInit() {
    super.onInit();
    _color.value = _loadThemeFromBox ? Colors.white : Colors.black;
  }

  switchTheme() async {
    await _box.write(_key, !_loadThemeFromBox);
    Get.changeThemeMode(theme);
    _color.value = _loadThemeFromBox ? Colors.white : blackClr;
  }
}
