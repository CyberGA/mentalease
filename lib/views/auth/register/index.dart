import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/shared/form.dart';
import 'package:mentalease/views/auth/register/user_details.dart';
import 'package:mentalease/views/auth/register/verification.dart';

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
        return verification(func: () {});
      case 2:
        return UserDetails(
          submitFunc: () {
            debugPrint("Submitting");
          },
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
                    step = 2;
                  });
                }),
          ),
        ],
      );
}
