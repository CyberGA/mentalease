import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/repository/exceptions/auth.dart';
import 'package:mentalease/colors.dart';
import 'package:mentalease/shared/popup.dart';
import 'package:mentalease/shared/utils.dart';
import 'package:mentalease/views/auth/controllers/auth_controller.dart';
import 'package:mentalease/views/dashboard/chats/index.dart';

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
    Utils.statusChange(cBar: cMain, cBarIconBrightness: Brightness.light, cNav: cWhite);
    super.initState();
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
                    tabs: const [Tab(text: "Chats"), Tab(text: "Groups")],
                  ),
                  title: Text(
                    "MentalEase",
                    style: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: cWhite,
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: "Profile",
                            child: Text(
                              "Profile",
                              style: GoogleFonts.openSans(fontSize: 18, color: cBlack.withOpacity(0.5), fontWeight: FontWeight.w500),
                            ),
                          ),
                          PopupMenuItem(
                            value: "Logout",
                            onTap: () {
                              controller.logout().then((res) {
                                if (res is AuthFailure) {
                                  popup(text: res.message, type: Notify.error, title: "Error");
                                } else {
                                  customPopup(text: "You have successfully logged out", title: "Logout", bg: cWhite, textClr: cBlack.withOpacity(0.6));
                                }
                              });
                            },
                            child: Text(
                              "Logout",
                              style: GoogleFonts.openSans(fontSize: 18, color: cBlack.withOpacity(0.5), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ];
                      },
                    )
                  ],
                ),
              ];
            }),
            body: TabBarView(children: [
              const Chats(),
              Container(),
            ])),
      )),
    );
  }
}
