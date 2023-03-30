import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentalease/shared/colors.dart';
import 'package:mentalease/shared/utils.dart';
import 'package:mentalease/views/auth/controllers/auth_controller.dart';


class Onboarding extends StatefulWidget {
  static const String route = "/onboarding";
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final AuthController _controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    Utils.statusChange(cBar: cMain, cBarIconBrightness: Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 2), () {
    //   _controller.isUserVerified().then((res) {
    //     if (res is! AuthFailure && res != true) {
    //       Navigator.pushReplacementNamed(context, Auth.route);
    //     }
    //   });\\
    // });

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
