import 'package:flutter/material.dart';
import 'package:mentalease/routes.dart';
import 'package:mentalease/shared/colors.dart';
import 'package:mentalease/views/onboarding/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MentalEase',
      theme: ThemeData.light().copyWith(
        primaryColor: cMain,
        scaffoldBackgroundColor: cWhite,
      ),
      initialRoute: Onboarding.route,
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}