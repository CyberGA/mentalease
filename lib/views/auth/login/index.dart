import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/repository/exceptions/auth.dart';
import 'package:mentalease/shared/auth_form.dart';
import 'package:mentalease/shared/popup.dart';
import 'package:mentalease/views/auth/controllers/auth_controller.dart';
import 'package:mentalease/views/auth/verification.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../colors.dart';
import '../../../models/role.dart';
import '../../../module/localDB.dart';
import '../../../shared/utils.dart';

class Login extends StatefulWidget {
  static const String route = "/auth/login";
  final int initStep;
  const Login({super.key, this.initStep = 0});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late TabController _tabController;
  late int step;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    Utils.statusChange(cBar: cWhite, cBarIconBrightness: Brightness.dark, cNav: cWhite);
    step = widget.initStep;
    _tabController = TabController(length: 2, vsync: this);
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
            context.loaderOverlay.show();
            FirebaseAuth.instance.currentUser!.reload().then((value) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                controller.updateVerificationStatus().then((res) {
                  if (res is AuthFailure) {
                    popup(text: res.message, title: "Error", type: Notify.error);
                  }
                  context.loaderOverlay.hide();
                });
              } else {
                popup(text: "Email has not verified", title: "Error", type: Notify.error);
                context.loaderOverlay.hide();
              }
            });
          },
          func: () {
            context.loaderOverlay.show();
            controller.verifyEmail().then((res) {
              if (res is AuthFailure) {
                popup(text: res.message, title: "Error", type: Notify.error);
              } else {
                popup(text: "Email verification link sent", title: "Email sent", type: Notify.success);
              }
              context.loaderOverlay.hide();
            });
          },
          text: "A verification link has been sent to the ${controller.email.text.trim()}. Please click on the link to verify your email address",
          btn: "Resend",
        );
      default:
        return _login();
    }
  }

  Widget _login() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 40),
        Container(
          margin: const EdgeInsets.all(24),
          child: TabBar(
            controller: _tabController,
            splashBorderRadius: BorderRadius.circular(100),
            unselectedLabelColor: cMain.withOpacity(0.4),
            labelColor: cWhite,
            labelStyle: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 20),
            unselectedLabelStyle: GoogleFonts.openSans(fontSize: 20),
            indicator: BoxDecoration(
              color: cMain,
              borderRadius: BorderRadius.circular(100),
            ),
            tabs: const [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("User"),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Therapist"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
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
                  context.loaderOverlay.show();
                  LocalDB.saveUserRole(_tabController.index);

                  if (_formKey.currentState!.validate()) {
                    try {
                      Role role = _tabController.index == 0 ? Role.user : Role.therapist;
                      controller.login(role).then((res) {
                        if (res is AuthFailure) {
                          popup(text: res.message, title: "Error", type: Notify.error);
                          context.loaderOverlay.hide();
                        }
                        context.loaderOverlay.hide();
                      });
                    } catch (err) {
                      popup(text: "Something went wrong", title: "Error", type: Notify.error);
                      context.loaderOverlay.hide();
                    }
                  }
                }),
          ),
        ),
      ]);
}
