import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

Widget options({required String text, required TextEditingController controller, required BuildContext context, required VoidCallback func}) => InkWell(
      onTap: () {
        func();
        controller.text = text;
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 60,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: cBlack.withOpacity(0.2)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.openSans(color: cBlack.withOpacity(0.6), fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );

Widget closeOptions({required BuildContext context}) => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                margin: const EdgeInsets.only(top: 16, right: 16), child: Text("CLOSE", style: GoogleFonts.openSans(color: cBlack.withOpacity(0.3), fontSize: 18, fontWeight: FontWeight.w700)))),
      ],
    );
