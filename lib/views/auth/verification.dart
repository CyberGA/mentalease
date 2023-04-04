import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/shared/primary_btn.dart';

import '../../colors.dart';
import 'controllers/auth_controller.dart';

class Verification extends StatefulWidget {
  final VoidCallback func;
  final String text;
  final String btn;
  final VoidCallback done;
  const Verification({super.key, required this.func, required this.text, required this.btn, required this.done});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cWhite,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                controller.logout().then((value) {
                  controller.fullName.text = "";
                  controller.username.text = "";
                  controller.role.text = "";
                });
              },
              icon: const Icon(Icons.close, color: cBlack, size: 26))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Icon(
              Icons.mail,
              color: cMain.withOpacity(0.6),
              size: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(color: cMain, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            primaryBtn(
                    btnSize: const Size(150, 50),
                    text: widget.btn,
                func: () {
                  widget.func();
                    },
                    outlined: true),
            const SizedBox(height: 10),
            primaryBtn(
                    btnSize: const Size(150, 50),
                    text: "Done",
                func: () {
                  widget.done();
                    },
                    outlined: false),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
