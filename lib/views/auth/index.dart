import 'package:flutter/material.dart';
import 'package:mentalease/shared/colors.dart';
import 'package:mentalease/shared/primary_btn.dart';
import 'package:mentalease/shared/utils.dart';
import 'package:mentalease/views/auth/login/index.dart';
import 'package:mentalease/views/auth/register/index.dart';

class Auth extends StatefulWidget {
  static const String route = "/auth";
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  void initState() {
    super.initState();
    Utils.statusChange(cBar: cWhite, cBarIconBrightness: Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/login.png"),
            const SizedBox(height: 60),
            primaryBtn(btnSize: const Size(250, 50), text: "Login", func: () => Navigator.pushNamedAndRemoveUntil(context, Login.route, (route) => false), outlined: true),
            const SizedBox(height: 20),
            primaryBtn(btnSize: const Size(250, 50), text: "Sign up", func: () => Navigator.pushNamedAndRemoveUntil(context, Register.route, (route) => false), outlined: false),
          ],
        ),
      ),
    );
  }
}
