import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

getPlaceHolder() async {
   await getImageFileFromAssets('user.png');
}

AppBar appBar(String text, Color textColor, Color iconColor ) {
  return AppBar(
    backgroundColor: Colors.transparent,
    title: Text(
      text,
      style: TextStyle(color: textColor),
    ),
    leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back, color: iconColor)),
  );
}