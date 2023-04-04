import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/colors.dart';
import 'package:mentalease/models/role.dart';
import 'package:mentalease/module/localDB.dart';
import 'package:mentalease/shared/utils.dart';
import 'package:mentalease/views/auth/controllers/auth_controller.dart';
import 'package:mentalease/views/dashboard/chats/index.dart';
import 'package:mentalease/views/dashboard/profile/index.dart';

class Dashboard extends StatefulWidget {
  static const String route = "/dashboard";
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthController controller = Get.put(AuthController());
  late Role? role;

  @override
  void initState() {
    super.initState();
    Utils.statusChange(cBar: cMain, cBarIconBrightness: Brightness.light, cNav: cWhite);
    role = LocalDB.getUserRole();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: DefaultTabController(
        length: 1,
        child: NestedScrollView(
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: cMain,
                  floating: true,
                  pinned: true,
                  snap: true,
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(50),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              "Chats",
                              style: GoogleFonts.openSans(color: cWhite, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                  title: Text(
                    "MentalEase ${role == Role.therapist ? "Therapist" : ""}",
                    style: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Profile.route);
                      },
                      icon: const Icon(Icons.account_circle, color: cWhite),
                    ),
                  ],
                ),
              ];
            }),
            body: const TabBarView(children: [Chats()])),
      )),
    );
  }
}
