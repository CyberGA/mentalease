import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/shared/primary_btn.dart';

import '../../../shared/colors.dart';
import '../../../shared/options.dart';

class UserDetails extends StatefulWidget {
  VoidCallback submitFunc;
  UserDetails({super.key, required this.submitFunc});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  int userType = 0;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        const SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("User Details", style: GoogleFonts.openSans(color: cMain, fontSize: 26, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 60),
        TextFormField(
          controller: controller,
          cursorColor: cMain,
          readOnly: true,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            filled: true,
            fillColor: cWhite,
            suffixIcon: Icon(
              Icons.arrow_drop_down_circle,
              color: cMain.withOpacity(0.6),
            ),
            hintText: "Select",
            hintStyle: GoogleFonts.openSans(color: cMain.withOpacity(0.4), fontSize: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: cMain.withOpacity(0.4))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: cMain)),
          ),
          onTap: () {
            showBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 156,
                    decoration: BoxDecoration(
                        color: cWhite,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        boxShadow: [BoxShadow(color: cBlack.withOpacity(0.25), offset: const Offset(0, 0), blurRadius: 6)]),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        closeOptions(context: context),
                        options(
                          text: "User",
                          context: context,
                          controller: controller,
                          func: () => setState((() {
                            userType = 0;
                          })),
                        ),
                        options(
                          text: "Psychologist",
                          context: context,
                          controller: controller,
                          func: () => setState((() {
                            userType = 1;
                          })),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          cursorColor: cMain,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            filled: true,
            fillColor: cWhite,
            hintText: "Full name",
            hintStyle: GoogleFonts.openSans(color: cMain.withOpacity(0.4), fontSize: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: cMain.withOpacity(0.4))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: cMain)),
          ),
          // onChanged: (val) => context.read<LoginBloc>().add(LoginEmailChanged(email: val)),
        ),
        const SizedBox(height: 20),
        TextFormField(
          cursorColor: cMain,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            filled: true,
            fillColor: cWhite,
            hintText: "Username",
            hintStyle: GoogleFonts.openSans(color: cMain.withOpacity(0.4), fontSize: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: cMain.withOpacity(0.4))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: cMain)),
          ),
          // onChanged: (val) => context.read<LoginBloc>().add(LoginEmailChanged(email: val)),
        ),
        userType == 1
            ? Container(
                margin: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    debugPrint("Upload Certification");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, color: cBlack.withOpacity(0.6), size: 28),
                      Text("Upload Certification", style: GoogleFonts.openSans(color: cBlack.withOpacity(0.8), fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )
            : Container(),
        const SizedBox(height: 60),
        primaryBtn(btnSize: const Size(200, 50), text: "Submit", func: widget.submitFunc, outlined: false)
      ],
    );
  }
}
