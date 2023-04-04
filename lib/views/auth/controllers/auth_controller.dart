import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mentalease/models/role.dart';
import 'package:mentalease/module/localDB.dart';
import 'package:mentalease/repository/auth_service.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final username = TextEditingController();
  final role = TextEditingController();

  //* call this function from the design
  Future registerUser() async {
    final response = await AuthService.instance.registerUserWithEmailAndPassword(email.text.trim(), password.text);
    return response;
  }

  Future completeProfile(
    String certPath,
    File? certFile,
    String picsPath,
    File pics,
  ) async {
    final user = role.text == "User" ? Role.user : Role.therapist;
    final response = await AuthService.instance.completeProfile(username.text.trim(), email.text.trim(), certPath, certFile, picsPath, pics, user, fullName.text.trim());
    return response;
  }

  Future verifyEmail() async {
    final response = await AuthService.instance.sendVerification();
    return response;
  }

  Future updateVerificationStatus() async {
    final userRole = role.text == "User" ? Role.user : Role.therapist;
    final response = await AuthService.instance.updateVerificationStatus(userRole);
    return response;
  }

  Future updateVisibility(bool status) async {
    final userRole = role.text == "User" ? Role.user : Role.therapist;
    final response = await AuthService.instance.updateUserVisibility(userRole, status);
    return response;
  }

  Future resetPassword() async {
    final response = await AuthService.instance.resetPassword(email.text.trim());
    return response;
  }

  Future login(Role role) async {
    final response = await AuthService.instance.loginUserWithEmailAndPassword(email.text.trim(), password.text, role);
    return response;
  }

  Future logout() async {
    email.text = "";
    password.text = "";
    fullName.text = "";
    username.text = "";
    role.text = "";
    LocalDB.removeUserRole();
    final response = await AuthService.instance.logout();
    return response;
  }
}
