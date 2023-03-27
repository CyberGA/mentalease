import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/shared/form.dart';

import '../../../shared/colors.dart';

class Login extends StatefulWidget {
  static const String route = "/auth/login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 40),
      Container(
        margin: const EdgeInsets.all(24),
        child: TabBar(
          controller: _tabController,
          splashBorderRadius: BorderRadius.circular(100),
          unselectedLabelColor: cMain.withOpacity(0.4),
          labelColor: cWhite,
          labelStyle: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 20),
          unselectedLabelStyle: GoogleFonts.openSans(fontSize: 20),
          indicator: BoxDecoration(
            color: cMain,
            borderRadius: BorderRadius.circular(100),
          ),
          tabs: const [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("User"),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Aid"),
            ),
          ],
        ),
      ),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Enter your login details", style: GoogleFonts.openSans(color: cMain, fontSize: 20)),
        ],
      ),
      Expanded(
        child: form(
            page: "Login",
            context: context,
            func: () {
              debugPrint("User type ${_tabController.index}");
            }),
      ),
    ])));
  }
}
