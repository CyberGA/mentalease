import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mentalease/shared/auth_form.dart';
import 'package:mentalease/shared/popup.dart';
import 'package:mentalease/views/auth/controllers/auth_controller.dart';
import 'package:mentalease/views/auth/login/index.dart';
import 'package:mentalease/views/auth/register/user_details.dart';

import '../../../services/exceptions/auth.dart';
import '../../../shared/colors.dart';

class Register extends StatefulWidget {
  static const String route = "/auth/register";
  final int initStep;
  const Register({super.key, this.initStep = 0});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final controller = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  late int step;

  @override
  void initState() {
    super.initState();
    step = widget.initStep;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body()),
    );
  }

  Widget body() {
    switch (step) {
      case 0:
        return signup(context);
      case 1:
        return UserDetails(
          controller: controller,
          submitFunc: () {
            Get.offAll(() => const Login(initStep: 1));
          },
        );
      default:
        return signup(context);
    }
  }

  Widget signup(BuildContext context) => Column(
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
            child: Form(
              key: _formKey,
              child: AuthForm(
                  controller: controller,
                  page: "Sign up",
                  context: context,
                  func: () {
                    if (_formKey.currentState!.validate()) {
                      context.loaderOverlay.show();
                      try {
                        controller.registerUser().then((res) {
                          if (res is AuthFailure) {
                            popup(text: res.message, title: "Error", type: Notify.error);
                          }
                        });
                      } catch (err) {
                        popup(text: "Something went wrong", title: "Error", type: Notify.error);
                      }
                      context.loaderOverlay.hide();
                    }
                  }),
            ),
          ),
        ],
      );
}
