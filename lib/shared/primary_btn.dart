import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/colors.dart';

Widget primaryBtn({required Size btnSize, required String text, required Function func, required bool outlined, double radius = 100}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: outlined ? 0 : 4,
            backgroundColor: !outlined ? cMain : cWhite,
            side: outlined ? BorderSide(color: cMain.withOpacity(0.6), width: 2) : null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
            minimumSize: Size(btnSize.width, 50),
          ),
          onPressed: () => func(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            child: Text(
              text,
              style: GoogleFonts.openSans(color: outlined ? cMain : cWhite, fontSize: 20, fontWeight: FontWeight.w700),
            ),
          )),
    ],
  );
}
