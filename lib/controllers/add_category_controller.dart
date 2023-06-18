import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../models/categories.dart';
import '../models/payment_mode_model.dart';
import '../providers/database_provider.dart';
import '../utils/constants.dart';

class AddCategoryController extends GetxController {

  final _box = GetStorage();
  final Rx<List<CategoriesModel>> _myCategories = Rx<List<CategoriesModel>>([]);
  List<CategoriesModel> get myCategories => _myCategories.value;
  final Rx<List<CashModel>> _myPaymentMode = Rx<List<CashModel>>([]);
  List<CashModel> get myPaymentMode => _myPaymentMode.value;

  @override
  void onInit() {
    super.onInit();
    getCategories();
    getCashMode();
  }

  getCategories() async {
    final List<CategoriesModel> categoriesFromDB = [];
    List<Map<String, dynamic>> categories = await DatabaseProvider.queryCategory();
    categoriesFromDB.assignAll(categories.reversed
        .map((data) => CategoriesModel().fromJson(data))
        .toList());
    _myCategories.value = categoriesFromDB;
    if(categoriesFromDB.isEmpty){
      _box.write(IS_DB_INITIALISED, false);
    }
  }

  Future<int> insertCategory(CategoriesModel categoriesModel) async {
    return await DatabaseProvider.insertCategory(categoriesModel);
  }

  Future<int> deleteCategory(int id) async {
    return await DatabaseProvider.deleteCategory(id);
  }

  Future<int> updateCategory(CategoriesModel categoriesModel) async {
    return await DatabaseProvider.updateCategory(categoriesModel);
  }

  getCashMode() async {
    final List<CashModel> cashModeFromDB = [];
    List<Map<String, dynamic>> modes = await DatabaseProvider.queryModes();
    cashModeFromDB.assignAll(modes.reversed
        .map((data) => CashModel().fromJson(data))
        .toList());
    _myPaymentMode.value = cashModeFromDB;
    if(cashModeFromDB.isEmpty){
      _box.write(IS_DB_INITIALISED, false);
    }
  }

  Future<int> insertPaymentMode(CashModel cashModel) async {
    return await DatabaseProvider.insertMode(cashModel);
  }

  Future<int> deletePaymentMode(int id) async {
    return await DatabaseProvider.deleteCashMode(id);
  }


}
