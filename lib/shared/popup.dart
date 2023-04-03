import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors.dart';

enum Notify { error, success }

void popup({
  required String text,
  String title = "",
  required Notify type,
}) {
  Get.snackbar(
    title,
    text,
    snackPosition: SnackPosition.TOP,
    backgroundColor: type == Notify.error ? cError : cMain,
    colorText: cWhite,
    margin: const EdgeInsets.all(16),
    animationDuration: const Duration(milliseconds: 250),
  );
}

void customPopup({required String text, String title = "", required Color bg, required Color textClr}) {
  Get.snackbar(
    title,
    text,
    snackPosition: SnackPosition.TOP,
    backgroundColor: bg,
    colorText: textClr,
    margin: const EdgeInsets.all(16),
    animationDuration: const Duration(milliseconds: 250),
  );
}

