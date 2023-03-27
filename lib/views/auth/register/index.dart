import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/shared/form.dart';
import 'package:mentalease/views/auth/login/index.dart';
import 'package:mentalease/views/auth/register/user_details.dart';
import 'package:mentalease/views/auth/verification.dart';

import '../../../shared/colors.dart';

class Register extends StatefulWidget {
  static const String route = "/auth/register";
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body()),
    );
  }

  Widget body() {
    switch (step) {
      case 0:
        return signup();
      case 1:
        return UserDetails(
          submitFunc: () {
            setState(() {
              step = 2;
            });
          },
        );
      case 2:
        return verification(
          func: () => Navigator.pushNamedAndRemoveUntil(context, Login.route, (route) => false),
          text: "A verification link has been sent to the email you provided. Please click on the link to verify your email address",
          btn: "Resend",
        );
      default:
        return signup();
    }
  }

  Widget signup() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign up", style: GoogleFonts.openSans(color: cMain, fontSize: 26)),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: form(
                page: "Sign up",
                context: context,
                func: () {
                  setState(() {
                    step = 1;
                  });
                }),
          ),
        ],
      );
}
