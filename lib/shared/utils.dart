import 'package:flutter/services.dart';

import 'colors.dart';

class Utils {
  static statusChange({
    Color cBar = cWhite,
    Brightness cBarIconBrightness = Brightness.dark,
  }) {
    //? This changes the color scheme of the status
    return SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: cBar,
      statusBarIconBrightness: cBarIconBrightness,
      systemNavigationBarColor: cBar,
      systemNavigationBarIconBrightness: cBarIconBrightness,
    ));
  }

  //& Todo
  static hideStatusBar() {
    return SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
  }

  static int mockHeight = 812;
  static int mockWidth = 375;
}
