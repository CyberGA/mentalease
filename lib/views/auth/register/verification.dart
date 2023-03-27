import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/shared/primary_btn.dart';

import '../../../shared/colors.dart';

Widget verification({required VoidCallback func}) {
  return Center(
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
            "A verification link has been sent to the email you provided. Please click on the link to verify your email address",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(color: cMain, fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
        primaryBtn(btnSize: const Size(150, 50), text: "Resend", func: func, outlined: true),
        const Spacer(),
      ],
    ),
  );
}
