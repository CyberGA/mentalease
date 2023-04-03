import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentalease/firebase_options.dart';
import 'package:mentalease/repository/chat_service.dart';
import 'package:mentalease/routes.dart';
import 'package:mentalease/repository/auth_service.dart';
import 'package:mentalease/colors.dart';
import 'package:mentalease/views/onboarding/index.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'module/localDB.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDB.init();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthService())).then((value) => Get.put(ChatService()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CircularProgressIndicator(color: cMain),
      ),
      overlayColor: cBlack.withOpacity(0.3),
      overlayOpacity: 1,
      child: GetMaterialApp(
        title: 'MentalEase',
        theme: ThemeData.light().copyWith(
          primaryColor: cMain,
          scaffoldBackgroundColor: cWhite,
        ),
        initialRoute: Onboarding.route,
        routes: appRoutes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
