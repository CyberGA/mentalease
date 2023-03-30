import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/repository/exceptions/auth.dart';
import 'package:mentalease/shared/colors.dart';
import 'package:mentalease/shared/popup.dart';
import 'package:mentalease/shared/primary_btn.dart';
import 'package:mentalease/shared/utils.dart';
import 'package:mentalease/views/auth/controllers/auth_controller.dart';

class Dashboard extends StatefulWidget {
  static const String route = "/dashboard";
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthController controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    Utils.statusChange(cBar: cMain, cBarIconBrightness: Brightness.light, cNav: cWhite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: cMain,
                  floating: true,
                  pinned: true,
                  snap: true,
                  bottom: TabBar(
                    unselectedLabelColor: cWhite.withOpacity(0.4),
                    labelColor: cWhite,
                    labelStyle: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                    unselectedLabelStyle: GoogleFonts.openSans(fontSize: 16),
                    indicatorColor: cWhite,
                    indicatorWeight: 2,
                    tabs: const [Tab(text: "Therapists"), Tab(text: "Private")],
                  ),
                  title: Text(
                    "MentalEase",
                    style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                      ),
                    ),
                  ],
                ),
              ];
            }),
            body: TabBarView(children: [
              _therapist(),
              Container(),
            ])),
      )),
    );
  }

  Widget _therapist() => ListView.builder(
        itemCount: 40,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              const SizedBox(height: 20),
              primaryBtn(
                  btnSize: const Size(250, 50),
                  text: "Logout",
                  func: () {
                    controller.logout().then((res) {
                      if (res is AuthFailure) {
                        Get.snackbar("Error", res.message);
                        popup(text: res.message, type: Notify.error, title: "Error");
                      } else {
                        popup(text: "Logged out successfully", title: "Logout", type: Notify.success);
                      }
                    });
                  },
                  outlined: false),
              const SizedBox(height: 20),
            ],
          );
        },
      );
}
