import 'dart:ffi';

import 'package:flutter_expense_tracker_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final _box = GetStorage();
  final Rx<String> _name = ''.obs;
  final Rx<String> _phone = ''.obs;
  final Rx<String> _email = ''.obs;
  final Rx<double> _budget = 0.0.obs;
  String get userName => _name.value;
  String get phone => _phone.value;
  String get email => _email.value;
  double get budget => _budget.value;

  final Rx<String> _selectedImage = Rx<String>('');
  String get selectedImage => _selectedImage.value;

  @override
  void onInit() {
    super.onInit();
    if(_box.read(USER_NAME) !=null) {
      _name.value = _box.read(USER_NAME);
    }
    if(_box.read(PHONE) !=null) {
      _phone.value = _box.read(PHONE);
    }
    if(_box.read(EMAIL) !=null) {
      _email.value = _box.read(EMAIL);
    }
    if(_box.read(SET_BUDGET) !=null) {
      _budget.value = _box.read(SET_BUDGET);
    }
    if(_box.read(USER_IMAGE) !=null) {
      _selectedImage.value = _box.read(USER_IMAGE);
    }
  }

  updateUserName(String name) async {
    _name.value = name;
    await _box.write(USER_NAME, name);
  }

  updatePhoneNumber(String phone) async {
    _phone.value = phone;
    await _box.write(PHONE, phone);
  }

  updateEmail(String email) async {
    _email.value = email;
    await _box.write(EMAIL, email);
  }

  updateBudget(double budget) async {
    _budget.value = budget;
    await _box.write(SET_BUDGET, budget);
  }

  updateSelectedImage(String path) async{
    _selectedImage.value = path;
    await _box.write(USER_IMAGE, path);
    Get.back();
  }
}
