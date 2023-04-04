import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mentalease/colors.dart';
import 'package:mentalease/module/hash.dart';
import 'package:mentalease/shared/popup.dart';

import '../../../firebase.dart';
import '../../../models/role.dart';
import '../../../module/localDB.dart';
import '../../../repository/exceptions/auth.dart';
import '../../auth/controllers/auth_controller.dart';

class Profile extends StatefulWidget {
  static const String route = "/profile";
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthController controller = Get.put(AuthController());

  late Role? role;
  final Color appBar = const Color(0XFF08787B);

  @override
  void initState() {
    super.initState();
    role = LocalDB.getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = fAuth.currentUser;
    final uid = Crypto.hash(currentUser!.email.toString());
    final DocumentReference usersRef = role == Role.therapist ? therapistsCollection.doc(uid) : usersCollection.doc(uid);
    final Stream<DocumentSnapshot> user = usersRef.snapshots();

    Widget profileRow({required IconData icon, required String label, required String text}) => Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: cBlack.withOpacity(0.6)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: cBlack.withOpacity(0.2), width: 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.openSans(fontSize: 14, color: cBlack.withOpacity(0.4)),
                        ),
                        Text(
                          text,
                          style: GoogleFonts.openSans(fontSize: 20, color: cBlack, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.only(left: 10),
                    //   child: Icon(Icons.edit, color: cWhite),
                    // ),
                  ],
                ),
              )
            ],
          ),
        );

    return Scaffold(
      backgroundColor: cWhite,
      appBar: AppBar(
        backgroundColor: cMain,
        elevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: StreamBuilder(
              stream: user,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: cMain),
                  );
                }

                final data = snapshot.data;

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                            child: Image.network(
                          data!["photo"],
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(width: 200, height: 200, color: cBlack.withOpacity(0.3), child: Icon(Icons.person, size: 100, color: cWhite.withOpacity(0.8)));
                          },
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ))
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        data["username"],
                        style: GoogleFonts.openSans(fontSize: 26, color: cBlack, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    profileRow(icon: Icons.person, label: "Full Name", text: data["fullName"]),
                    profileRow(icon: Icons.mail, label: "Email Address", text: currentUser.email.toString()),
                    const SizedBox(height: 60),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.loaderOverlay.show();
                          controller.logout().then((res) {
                            if (res is AuthFailure) {
                              popup(text: res.message, type: Notify.error, title: "Error");
                            } else {
                              customPopup(text: "You have successfully logged out", title: "Logout", bg: cWhite, textClr: cBlack.withOpacity(0.6));
                            }
                            context.loaderOverlay.hide();
                          });
                        },
                        child: Text(
                          "Logout",
                          style: GoogleFonts.openSans(
                            fontSize: 24,
                            color: cBlack.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
