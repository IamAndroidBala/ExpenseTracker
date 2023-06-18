import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/controllers/add_category_controller.dart';
import 'package:flutter_expense_tracker_app/models/categories.dart';
import 'package:flutter_expense_tracker_app/utils/common_methods.dart';
import 'package:flutter_expense_tracker_app/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';
import '../../models/payment_mode_model.dart';
import '../../utils/colors.dart';
import '../../utils/theme.dart';

class AddCategoriesScreen extends StatefulWidget {
  AddCategoriesScreen({Key? key, required this.title, required this.isBack})
      : super(key: key);
  final String title;
  final bool isBack;

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  final _themeController = Get.find<ThemeController>();
  final _addCategoryController = Get.put(AddCategoryController());
  final _textFieldController = TextEditingController();
  final _budgetFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: appBar(
            widget.title, _themeController.color, _themeController.color),
        body: ListView.builder(
          itemCount: widget.title == ADD_CATEGORY
              ? _addCategoryController.myCategories.length
              : _addCategoryController.myPaymentMode.length,
          itemBuilder: (context, i) {
            final type = widget.title == ADD_CATEGORY
                ? _addCategoryController.myCategories[i].type!
                : _addCategoryController.myPaymentMode[i].type!;
            final id = widget.title == ADD_CATEGORY
                ? _addCategoryController.myCategories[i].id!
                : _addCategoryController.myPaymentMode[i].id!;
            final budget = widget.title == ADD_CATEGORY
                ? _addCategoryController.myCategories[i].budget!
                : _addCategoryController.myPaymentMode[i].budget!;
            return GestureDetector(
              onTap: () async {},
              child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        type.trim(),
                        style: Themes().subHeadingTextStyle,
                      ),
                      Spacer(),
                      Text(
                        'Budget : ${budget.toStringAsFixed(2)}',
                        style: Themes().subHeadingTextStyle,
                      )
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      if (widget.title == ADD_CATEGORY) {
                        _addCategoryController.deleteCategory(id);
                        setState(() {
                          _addCategoryController.getCategories();
                        });
                      } else if (widget.title == ADD_MODE) {
                        _addCategoryController.deletePaymentMode(id);
                        setState(() {
                          _addCategoryController.getCashMode();
                        });
                      }
                    },
                    icon: Icon(Icons.delete),
                    color: _themeController.color,
                  )),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () async {
            _displayTextInputDialog(context);
          },
          child: Icon(
            Icons.add,
          ),
        ),
      );
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.title == ADD_CATEGORY ? ADD_CATEGORY : ADD_MODE),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {},
                  controller: _textFieldController,
                  decoration: InputDecoration(
                      hintText: widget.title == ADD_CATEGORY
                          ? 'Enter a category'
                          : 'Enter a payment mode'),
                ),
                TextField(
                  onChanged: (value) {},
                  controller: _budgetFieldController,
                  decoration:
                      InputDecoration(hintText: 'Budget for this category'),
                )
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                color: primaryColor,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  if (_textFieldController.text.toString().isNotEmpty &&
                      _budgetFieldController.text.toString().isNotEmpty) {
                    if (widget.title == ADD_CATEGORY) {
                      _addCategoryController.insertCategory(
                          CategoriesModel(type: _textFieldController.text, budget: double.parse(_budgetFieldController.text.toString())));
                      _textFieldController.text = '';
                      _budgetFieldController.text = '';
                      setState(() {
                        _addCategoryController.getCategories();
                      });
                    } else {
                      _addCategoryController.insertPaymentMode(
                          CashModel(type: _textFieldController.text,  budget: double.parse(_budgetFieldController.text.toString())));
                      _textFieldController.text = '';
                      _budgetFieldController.text = '';
                      setState(() {
                        _addCategoryController.getCashMode();
                      });
                    }
                    Get.back();
                  } else {
                    Fluttertoast.showToast(msg: 'Fill all the values');
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _textFieldController.dispose();
    _budgetFieldController.dispose();
  }
}
