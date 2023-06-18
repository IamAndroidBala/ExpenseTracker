import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/controllers/settings_controller.dart';
import 'package:flutter_expense_tracker_app/utils/constants.dart';
import 'package:flutter_expense_tracker_app/views/screens/add_categories_screen.dart';
import 'package:flutter_expense_tracker_app/views/screens/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/theme_controller.dart';
import '../../utils/common_methods.dart';

class EditPersonalDetailsScreen extends StatefulWidget {
  const EditPersonalDetailsScreen( {required this.from, Key? key}) : super(key: key);
  final String from;
  @override
  State<EditPersonalDetailsScreen> createState() => _EditPersonalDetailsScreenState();
}

class _EditPersonalDetailsScreenState extends State<EditPersonalDetailsScreen> {

  final _themeController = Get.find<ThemeController>();
  final _settingsController = Get.put(SettingsController());
  var usernameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var budgetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _box = GetStorage();

  @override
  void initState() {
    super.initState();
    usernameController.text = _settingsController.userName;
    phoneController.text = _settingsController.phone;
    emailController.text = _settingsController.email;
    budgetController.text = _settingsController.budget.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: appBar('Edit Details', _themeController.color, _themeController.color),
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  const SizedBox(height: 10.0),
                  _settingsController.selectedImage.isNotEmpty
                      ? GestureDetector(
                    onTap: () => _showOptionsDialog(context),
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundImage: FileImage(
                        File(_settingsController.selectedImage),
                      ),
                    ),
                  )
                      : GestureDetector(
                    onTap: () => _showOptionsDialog(context),
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundColor: Get.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      child: Center(
                        child: Icon(
                          Icons.add_a_photo,
                          color: _themeController.color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'User name',
                      hintText: 'Enter Username',
                      icon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'User name cant be blank';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      hintText: 'Enter Phone Number',
                      icon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone Number cant be blank';
                      } else if(!value.isPhoneNumber) {
                        return 'Enter valid Phone Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter Email Address',
                      icon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email Address cant be blank';
                      } else if(!value.isEmail) {
                        return 'Enter valid Email Address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: budgetController,
                    decoration: InputDecoration(
                      labelText: 'Budget',
                      hintText: 'Enter Monthly Budget',
                      icon: const Icon(Icons.monetization_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an amount';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _box.write(USER_NAME, usernameController.text);
                          _box.write(PHONE, phoneController.text);
                          _box.write(EMAIL, emailController.text);
                          _box.write(SET_BUDGET, budgetController.text);
                          _settingsController.updateUserName(usernameController.text);
                          _settingsController.updatePhoneNumber(phoneController.text);
                          _settingsController.updateEmail(emailController.text);
                          _settingsController.updateBudget(double.parse(budgetController.text.toString()));
                          _box.write(APP_INITIALISED, true);
                          Get.off(()=>HomeScreen());
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  _settingsController.updateSelectedImage(image.path);
                }
              },
              child: Row(children: [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7),
                  child: Text(
                    'Galley',
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                )
              ]),
            ),
            SimpleDialogOption(
              onPressed: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  _settingsController.updateSelectedImage(image.path);
                }
              },
              child: Row(children: [
                Icon(Icons.camera),
                Padding(
                  padding: EdgeInsets.all(7),
                  child: Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                )
              ]),
            ),
            SimpleDialogOption(
              onPressed: () => Get.back(),
              child: Row(children: [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                )
              ]),
            ),
          ],
        ));
  }

}


