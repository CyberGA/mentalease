import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/colors.dart';
import 'package:mentalease/shared/primary_btn.dart';
import 'package:mentalease/views/auth/controllers/auth_controller.dart';
import 'package:mentalease/views/auth/login/index.dart';
import 'package:mentalease/views/auth/login/reset_password.dart';
import 'package:mentalease/views/auth/register/index.dart';

class AuthForm extends StatefulWidget {
  final AuthController controller;
  final String page;
  final VoidCallback func;
  final BuildContext context;

  const AuthForm({super.key, required this.controller, required this.page, required this.func, required this.context});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isPwdVisible = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 40, 24, 10),
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Text("Email", style: GoogleFonts.openSans(color: cMain, fontSize: 20)),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.controller.email,
            validator: (value) {
              if (value!.isEmpty) {
                return "Email is required";
              }
              if (!value.contains("@")) {
                return "Please enter a valid email";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
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
          TextFormField(
            controller: widget.controller.password,
            validator: (value) {
              if (value!.isEmpty) {
                return "Password is required";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
            obscureText: isPwdVisible,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: "Enter your password",
              hintStyle: GoogleFonts.openSans(color: cMain.withOpacity(0.4), fontSize: 20),
              suffixIcon: isPwdVisible == true
                  ? IconButton(
                      onPressed: () => setState(() {
                            isPwdVisible = false;
                          }),
                      icon: Icon(Icons.visibility, color: cBlack.withOpacity(0.5)))
                  : IconButton(
                      onPressed: () => setState(() {
                            isPwdVisible = true;
                          }),
                      icon: Icon(Icons.visibility_off, color: cBlack.withOpacity(0.5))),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: cMain.withOpacity(0.4))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: cMain)),
            ),
          ),
          const SizedBox(height: 10),
          widget.page == "Login"
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
              Text(widget.page == "Login" ? "Don't have an account? " : "Already have an account? ", style: GoogleFonts.openSans(color: cMain, fontSize: 18)),
              widget.page == "Login"
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
          primaryBtn(
              btnSize: const Size(150, 50),
              text: widget.page,
              func: () {
                widget.func();
              },
              outlined: false)
        ],
      ),
    );
  }
}
