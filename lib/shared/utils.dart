import 'dart:math';

import 'package:flutter/services.dart';

import '../colors.dart';

class Utils {
  static statusChange({
    Color cBar = cWhite,
    Brightness cBarIconBrightness = Brightness.dark,
    Color? cNav
  }) {
    //? This changes the color scheme of the status
    return SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: cBar,
      statusBarIconBrightness: cBarIconBrightness,
      systemNavigationBarColor: cNav ?? cBar,
      systemNavigationBarIconBrightness: cBarIconBrightness,
    ));
  }

  //& Todo
  static hideStatusBar() {
    return SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
  }

  static int mockHeight = 812;
  static int mockWidth = 375;

  static String idGenerator({int len = 16}) {
    String data = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";

    final random = Random();

    String str = "";

    for (int i = 0; i < len; i++) {
      final index = random.nextInt(data.length);
      str += data[index];
    }

    return str;
  }
}
