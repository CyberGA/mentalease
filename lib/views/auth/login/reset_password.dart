import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/shared/primary_btn.dart';
import 'package:mentalease/views/auth/login/index.dart';
import 'package:mentalease/views/auth/verification.dart';

import '../../../shared/colors.dart';

class ResetPassword extends StatefulWidget {
  static const String route = "/auth/reset";
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> with TickerProviderStateMixin {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    switch (step) {
      case 0:
        return _resetForm();
      case 1:
        return verification(
            func: () {
              Navigator.pushNamedAndRemoveUntil(context, Login.route, (route) => false);
            },
            text: "Please check the email address provided, click on the link and reset your password",
            btn: "Continue");
      default:
        return _resetForm();
    }
  }

  Widget _resetForm() => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        children: [
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const BackButton(
                color: cMain,
              ),
              Text(
                "Reset Password",
                style: GoogleFonts.openSans(color: cMain, fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email", style: GoogleFonts.openSans(color: cMain, fontSize: 20)),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: GoogleFonts.openSans(color: cMain.withOpacity(0.4), fontSize: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: cMain.withOpacity(0.4))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: cMain)),
                  ),
                ),
                const SizedBox(height: 30),
                primaryBtn(
                    btnSize: const Size(150, 50),
                    text: "Submit",
                    func: () {
                      //! Send verification link to the provided email address
                      setState(() {
                        step = 1;
                      });
                    },
                    outlined: false)
              ],
            ),
          )
        ],
      );
}
