import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mentalease/models/role.dart';
import 'package:mentalease/services/auth_service.dart';

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

  Future completeProfile(String path, File? file) async {
    final user = role.text == "User" ? Role.user : Role.therapist;
    final response = await AuthService.instance.completeProfile(username.text.trim(), path, file, user, fullName.text.trim());
    return response;
  }

  Future verifyEmail() async {
    final response = await AuthService.instance.sendVerification();
    return response;
  }

  Future resetPassword() async {
    final response = await AuthService.instance.resetPassword(email.text.trim());
    return response;
  }

  Future isUserVerified() async {
    final response = await AuthService.instance.isUserVerified();
    return response;
  }

  Future login() async {
    final response = await AuthService.instance.loginUserWithEmailAndPassword(email.text.trim(), password.text);
    return response;
  }

  Future logout() async {
    email.text = "";
    password.text = "";
    final response = await AuthService.instance.logout();
    return response;
  }
}
