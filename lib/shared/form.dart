import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/shared/colors.dart';
import 'package:mentalease/shared/primary_btn.dart';
import 'package:mentalease/views/auth/login/index.dart';
import 'package:mentalease/views/auth/login/reset_password.dart';
import 'package:mentalease/views/auth/register/index.dart';

Widget form({required String page, required VoidCallback func, required BuildContext context}) => Container(
      margin: const EdgeInsets.fromLTRB(24, 40, 24, 10),
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
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
          const SizedBox(height: 20),
          Text("Password", style: GoogleFonts.openSans(color: cMain, fontSize: 20)),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter your password",
              hintStyle: GoogleFonts.openSans(color: cMain.withOpacity(0.4), fontSize: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: cMain.withOpacity(0.4))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: cMain)),
            ),
          ),
          const SizedBox(height: 10),
          page == "Login"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ResetPassword.route);
                      },
                      child: Text("Forgot Password?", style: GoogleFonts.openSans(color: cMain, fontSize: 18, fontWeight: FontWeight.w500))),
                  ],
                )
              : Container(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(page == "Login" ? "Don't have an account? " : "Already have an account? ", style: GoogleFonts.openSans(color: cMain, fontSize: 18)),
              page == "Login"
                  ? GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Register.route),
                      child: Text("Sign up",
                          style: GoogleFonts.openSans(
                            color: cMain,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          )))
                  : GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Login.route),
                      child: Text("Login",
                          style: GoogleFonts.openSans(
                            color: cMain,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ))),
            ],
          ),
          const SizedBox(height: 60),
          primaryBtn(btnSize: const Size(150, 50), text: page, func: func, outlined: false)
        ],
      ),
    );
