import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/repository/exceptions/auth.dart';
import 'package:mentalease/shared/popup.dart';
import 'package:mentalease/shared/primary_btn.dart';

import '../../../colors.dart';
import '../controllers/auth_controller.dart';

class ResetPassword extends StatefulWidget {
  static const String route = "/auth/reset";
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> with TickerProviderStateMixin {
  int step = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _resetForm()),
    );
  }

 

  Widget _resetForm() => Form(
        key: _formKey,
        child: ListView(
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
                  TextFormField(
                    controller: controller.email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }
                      if (!value.contains("@")) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
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
                        if (_formKey.currentState!.validate()) {
                          try {
                            controller.resetPassword().then((res) {
                              if (res is AuthFailure) {
                                popup(text: res.message, title: "Error", type: Notify.error);
                              } else {
                                popup(text: "Password reset link sent to ${controller.email.text}, follow the link to reset password", title: "Email sent", type: Notify.success);
                              }
                            });
                          } catch (err) {
                            popup(text: "Something went wrong", title: "Error", type: Notify.error);
                          }
                        }
                      },
                      outlined: false)
                ],
              ),
            )
          ],
        ),
      );
}
