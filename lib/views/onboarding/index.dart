import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentalease/colors.dart';
import 'package:mentalease/shared/utils.dart';
import 'package:mentalease/views/auth/login/index.dart';

class Onboarding extends StatefulWidget {
  static const String route = "/onboarding";
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
    Utils.statusChange(cBar: cMain, cBarIconBrightness: Brightness.light);
  }

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      backgroundColor: cMain,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
