import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mentalease/shared/popup.dart';
import 'package:mentalease/shared/primary_btn.dart';
import 'package:mentalease/views/auth/controllers/auth_controller.dart';

import '../../../module/localDB.dart';
import '../../../repository/exceptions/auth.dart';
import '../../../colors.dart';
import '../../../shared/options.dart';

class UserDetails extends StatefulWidget {
  final VoidCallback submitFunc;
  final AuthController controller;
  const UserDetails({super.key, required this.submitFunc, required this.controller});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  int userType = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? pickedFile;
  PlatformFile? photo;

  _selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf']);
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    } else {
      // User canceled the picker
    }
  }

  _uploadPhoto() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      setState(() {
        photo = result.files.first;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("User Details", style: GoogleFonts.openSans(color: cMain, fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          //* upload photo
          GestureDetector(
            onTap: _uploadPhoto,
            child: Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Container(
                      width: 200,
                      height: 200,
                      color: cMain.withOpacity(0.1),
                      child: photo != null
                          ? ClipOval(
                              child: Image.file(
                                File(photo!.path!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: cMain,
                              size: 50,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    right: 14,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: cMain,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: cWhite,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
          TextFormField(
            controller: widget.controller.role,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please select a user type";
              }
              return null;
            },
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
                            controller: widget.controller.role,
                            func: () => setState((() {
                              userType = 0;
                              LocalDB.saveUserRole(0);
                            })),
                          ),
                          options(
                            text: "Therapist",
                            context: context,
                            controller: widget.controller.role,
                            func: () => setState((() {
                              userType = 1;
                              LocalDB.saveUserRole(1);
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
            controller: widget.controller.fullName,
            validator: (value) {
              if (value!.isEmpty) {
                return "Name cannot be empty";
              }
              if (value.length < 2) {
                return "Name must be greater than two characters";
              }
              return null;
            },
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
          ),
          const SizedBox(height: 20),
          TextFormField(
            cursorColor: cMain,
            controller: widget.controller.username,
            validator: (value) {
              if (value!.trim().isEmpty) {
                return "Username cannot be empty";
              }
              if (value.length < 2) {
                return "Username must be greater than two characters";
              }
              return null;
            },
            textInputAction: TextInputAction.done,
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
          ),
          userType == 1
              ? Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: _selectFile,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, color: cBlack.withOpacity(0.6), size: 28),
                            Text("Upload Certification", style: GoogleFonts.openSans(color: cBlack.withOpacity(0.8), fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        pickedFile != null ? Text(pickedFile!.name, style: GoogleFonts.openSans(color: cBlack.withOpacity(0.8), fontSize: 18)) : Container(),
                      ],
                    ),
                  ),
                )
              : Container(),
          const SizedBox(height: 60),
          primaryBtn(
              btnSize: const Size(200, 50),
              text: "Submit",
              func: () {
                if (photo == null) {
                  popup(text: "Upload a profile picture", title: "Error", type: Notify.error);
                  return;
                }
                if (userType == 1 && pickedFile == null) {
                  popup(text: "Please upload a certification", title: "Error", type: Notify.error);
                  return;
                }
                context.loaderOverlay.show();
                if (_formKey.currentState!.validate()) {
                  String certPath = "";
                  File? certFile;

                  String picsPath = "";
                  File pics;

                  if (widget.controller.role.text.trim() == "Therapist") {
                    certPath = 'users/${widget.controller.username.text.trim()}/cert${pickedFile!.name}';
                    certFile = File(pickedFile!.path!);
                  }

                  picsPath = 'users/${widget.controller.username.text.trim()}/photo${photo!.name}';
                  pics = File(photo!.path!);

                  try {
                    widget.controller.completeProfile(certPath, certFile, picsPath, pics).then((res) {
                      if (res is AuthFailure) {
                        popup(text: res.message, title: "Error", type: Notify.error);
                      } else {
                        popup(
                          text: "Email verification link has been sent to ${widget.controller.email.text}, click on the link to verify your account",
                          title: "Verification mail sent",
                          type: Notify.success,
                        );

                        widget.submitFunc();
                      }
                      context.loaderOverlay.hide();
                    });
                  } catch (err) {
                    popup(text: "Something went wrong", title: "Error", type: Notify.error);
                    context.loaderOverlay.hide();
                  }
                }
              },
              outlined: false)
        ],
      ),
    );
  }
}
