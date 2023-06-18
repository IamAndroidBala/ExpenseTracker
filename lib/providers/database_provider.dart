import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/models/transaction.dart';
import 'package:flutter_expense_tracker_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';

import '../models/categories.dart';
import '../models/payment_mode_model.dart';
import '../utils/colors.dart';

class DatabaseProvider {
  static Database? _db;
  static final int _version = 1;
  static final String _tableTransaction = 'transactions';
  static final String _tableCategory = 'categories';
  static final String _tableMode = 'mode';
  static final String _path = 'transactions.db';
  static final _box = GetStorage();

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = await getDatabasesPath() + _path;

      _db = await openDatabase(path, version: _version, onCreate: (db, version) => db.execute('''
         CREATE TABLE $_tableTransaction(
          id STRING PRIMARY KEY,
          type TEXT, image TEXT, name TEXT, amount TEXT, 
          date TEXT, time TEXT, category TEXT, mode TEXT)
        '''));

     _db!.execute('''
         CREATE TABLE IF NOT EXISTS $_tableCategory(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT, budget DOUBLE)
        ''');

      _db!.execute('''
         CREATE TABLE IF NOT EXISTS $_tableMode(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT,  budget DOUBLE)
        ''');

      if(_box.read(IS_DB_INITIALISED) == null || _box.read(IS_DB_INITIALISED) == false) {
        insertCategory(CategoriesModel(type: 'Others', budget: 1000.0));
        insertMode(CashModel(type: 'Others', budget: 1000.0));
        _box.write(IS_DB_INITIALISED, true);
        _box.write('isDarkMode', false);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error initializing database',
        backgroundColor: Color(0xFF212121),
        colorText: pinkClr,
      );
    }
  }

  static Future<int> insertTransaction(TransactionModel transaction) async {
    return await _db!.insert(_tableTransaction, transaction.toMap());
  }

  static Future<int> deleteTransaction(String id) async {
    return await _db!.delete(_tableTransaction, where: 'id=?', whereArgs: [id]);
  }

  static Future<int> updateTransaction(TransactionModel tm) async {
    return await _db!.rawUpdate('''
      UPDATE $_tableTransaction 
      SET type = ?,
      image = ?,
      name = ?,
      amount = ?,
      date = ?,
      time = ?,
      category = ?,
      mode = ?
      WHERE id = ? 
      ''', [
      tm.type,
      tm.image,
      tm.name,
      tm.amount,
      tm.date,
      tm.time,
      tm.category,
      tm.mode,
      tm.id,
    ]);
  }

  static Future<List<Map<String, dynamic>>> queryTransaction() async {
    return await _db!.query(_tableTransaction);
  }


  /// category table CRUD
  static Future<int> insertCategory(CategoriesModel category) async {
    return await _db!.insert(_tableCategory, category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteCategory(int id) async {
    return await _db!.delete(_tableCategory, where: 'id=?', whereArgs: [id]);
  }

  static Future<int> updateCategory(CategoriesModel category) async {
    return await _db!.rawUpdate('''
      UPDATE $_tableCategory 
      SET type = ?,
      budget = ?,
      WHERE id = ? 
      ''', [
      category.type,
      category.id,
    ]);
  }

  static Future<List<Map<String, dynamic>>> queryCategory() async {
    return await _db!.query(_tableCategory,orderBy: 'id DESC');
  }

  /// cash mode table CRUD
  static Future<int> insertMode(CashModel cashModel) async {
    return await _db!.insert(_tableMode, cashModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> queryModes() async {
    return await _db!.query(_tableMode,orderBy: 'id DESC');
  }

  static Future<int> deleteCashMode(int id) async {
    return await _db!.delete(_tableMode, where: 'id=?', whereArgs: [id]);
  }

}
