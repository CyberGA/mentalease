import 'package:flutter/cupertino.dart';
import 'package:mentalease/views/auth/index.dart';
import 'package:mentalease/views/auth/login/index.dart';
import 'package:mentalease/views/auth/login/reset_password.dart';
import 'package:mentalease/views/auth/register/index.dart';
import 'package:mentalease/views/dashboard/index.dart';
import 'package:mentalease/views/onboarding/index.dart';

final appRoutes = <String, WidgetBuilder>{
  Onboarding.route: (context) => const Onboarding(),
  Auth.route: (context) => const Auth(),
  Login.route: (context) => const Login(),
  Register.route: (context) => const Register(),
  ResetPassword.route: (context) => const ResetPassword(),
  Dashboard.route: (context) => const Dashboard()
};
