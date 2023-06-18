import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/controllers/settings_controller.dart';
import 'package:flutter_expense_tracker_app/utils/constants.dart';
import 'package:flutter_expense_tracker_app/utils/theme.dart';
import 'package:flutter_expense_tracker_app/views/screens/add_categories_screen.dart';
import 'package:flutter_expense_tracker_app/views/screens/edit_personal_details.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final _box = GetStorage();
  final SettingsController _settingsController = Get.put(SettingsController());
  final _textFieldController = TextEditingController();
  final _themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        body: Center(
            child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 60.r,
                  backgroundImage: FileImage(
                    File(_settingsController.selectedImage),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(_settingsController.userName, style: Themes().headingTextStyle,),
                SizedBox(
                  height: 5,
                ),
                Text(_settingsController.phone, style: Themes().subHeadingTextStyle),
                SizedBox(
                  height: 5,
                ),
                Text(_settingsController.email, style: Themes().subHeadingTextStyle),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                'Edit Personal Details',
                style: Themes().labelStyle,
              ),
              onTap: () {
                Get.to(()=>EditPersonalDetailsScreen(from: 'Settings',));
              },
            ),
            
            ListTile(
              title: Text(
                'Add / View Category',
                style: Themes().labelStyle,
              ),
              onTap: () {
                Get.to(() => AddCategoriesScreen(title: ADD_CATEGORY,isBack: false, ));
              },
            ),
            
            ListTile(
              title: Text(
                'Add / View Cash Modes',
                style: Themes().labelStyle,
              ),
              onTap: () {
                Get.to(()=>AddCategoriesScreen(title: ADD_MODE,isBack: false));
              },
            ),

            ListTile(
              title: Text(!_settingsController.budget.isEqual(0.0)? 'Set Monthly Budget\nCurrent Budget is ${_box.read(SET_BUDGET)}' : 'Set Monthly Budget',
                style: Themes().labelStyle,
              ),
              onTap: () {
                _setBudget(context);
              },
            ),
            
          ],
        )),
      );
    });
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'Settings',
        style: TextStyle(color: _themeController.color),
      ),
      leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: _themeController.color)),
    );
  }

  Future<void> _setBudget(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Set Monthly Budget Limit'),
            content: TextField(
              onChanged: (value) {},
              controller: _textFieldController,
              decoration: InputDecoration(
                  hintText: 'Enter Amount Limit'),
            ),
            actions: <Widget>[
              MaterialButton(
                color: primaryColor,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  if(_textFieldController.text.isNotEmpty) {
                    _box.write(SET_BUDGET, _textFieldController.text);
                    _settingsController.updateBudget(
                        double.parse(_textFieldController.text));
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(msg: 'Enter a amount');
                  }
                },
              ),
            ],
          );
        });
  }

  _printReport() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello Flutter World"),
          ); // Center
        }
        )
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/newPDF.pdf");
    await file.writeAsBytes(await pdf.save()); // Page
    openPdfFromUrl(file.path);
  }

  void openPdfFromUrl(String url) {
    debugPrint('opening PDF url = $url');
    var googleDocsUrl = 'https://docs.google.com/gview?embedded=true&url=$url}';
    debugPrint('opening Google docs with PDF url = $googleDocsUrl');
    final Uri uri = Uri.parse(googleDocsUrl);
    launchUrl(uri);
  }

}
