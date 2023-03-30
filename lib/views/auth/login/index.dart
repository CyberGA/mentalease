import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/repository/exceptions/auth.dart';
import 'package:mentalease/shared/auth_form.dart';
import 'package:mentalease/shared/popup.dart';
import 'package:mentalease/views/auth/controllers/auth_controller.dart';
import 'package:mentalease/views/auth/verification.dart';

import '../../../shared/colors.dart';

class Login extends StatefulWidget {
  static const String route = "/auth/login";
  final int initStep;
  const Login({super.key, this.initStep = 0});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late int step;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    step = widget.initStep;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: _body(),
    ));
  }

  Widget _body() {
    switch (step) {
      case 0:
        return _login();
      case 1:
        return Verification(
          done: () {
            FirebaseAuth.instance.currentUser!.reload().then((value) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
              } else {
                popup(text: "Email has not verified", title: "Error", type: Notify.error);
              }
            });
          },
          func: () {
            try {
              controller.verifyEmail();
              popup(text: "Email verification link sent", title: "Email sent", type: Notify.success);
            } on AuthFailure catch (e) {
              popup(text: e.message, title: "Error", type: Notify.error);
            } catch (err) {
              popup(text: "Something went wrong", title: "Error", type: Notify.error);
            }
          },
          text: "A verification link has been sent to the email you provided. Please click on the link to verify your email address",
          btn: "Resend",
        );
      default:
        return _login();
    }
  }

  Widget _login() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter your login details", style: GoogleFonts.openSans(color: cMain, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: AuthForm(
                controller: controller,
                page: "Login",
                context: context,
                func: () {
                  //! check if user is verified
                  //! If user is verified, go to chat,
                  //! else go to verification page
                  if (_formKey.currentState!.validate()) {
                    try {
                      controller.login().then((res) {
                        if (res is AuthFailure) {
                          popup(text: res.message, title: "Error", type: Notify.error);
                          // errorPopup(text: res.message, context: context);
                        }
                      });
                    } catch (err) {
                      popup(text: "Something went wrong", title: "Error", type: Notify.error);
                    }
                    // controller.setLoading(false);
                  }
                }),
          ),
        ),
      ]);
}
