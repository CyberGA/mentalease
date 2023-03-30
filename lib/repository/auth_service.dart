// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mentalease/models/role.dart';
import 'package:mentalease/repository/exceptions/auth.dart';
import 'package:mentalease/views/auth/index.dart';
import 'package:mentalease/views/auth/login/index.dart';
import 'package:mentalease/views/auth/register/index.dart';
import 'package:mentalease/views/dashboard/index.dart';

class AuthService extends GetxController {
  static AuthService get instance => Get.find();

  // variables
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final CollectionReference _user = FirebaseFirestore.instance.collection("users");

  late final Rx<User?> firebaseUser;

  //* Set up the first screen
  _setInitialScreen(User? user) {
    Future.delayed(const Duration(seconds: 2), () {
      if (user == null) {
        Get.offAll(() => const Auth());
      } else {
        if (user.emailVerified) {
          Get.offAll(() => const Dashboard());
        }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  Future registerUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await sendVerification();
      firebaseUser.value == null ? Get.to(() => const Auth()) : Get.offAll(() => const Register(initStep: 1));
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      final err = AuthFailure.code(code: e.code);
      print(err.message);
      return err;
    } catch (e) {
      print(e);
      const err = AuthFailure();
      print(err.message);
      return err;
    }
  }

  Future sendVerification() async {
    try {
      await firebaseUser.value?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      final err = AuthFailure.code(code: e.code);
      print(err.message);
      return err;
    } catch (e) {
      print(e);
      const err = AuthFailure();
      print(err.message);
      return err;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.offAll(() => const Login());
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      final err = AuthFailure.code(code: e.code);
      print(err.message);
      return err;
    } catch (e) {
      print(e);
      const err = AuthFailure();
      print(err.message);
      return err;
    }
  }

  Future completeProfile(String username, String path, File? file, Role role, String fullName) async {
    final String certification;
    try {
      if (firebaseUser.value != null) {
        await firebaseUser.value?.updateDisplayName(username);
        if (file != null && role == Role.therapist) {
          final ref = _storage.ref().child(path);
          ref.putFile(file);
          certification = ref.fullPath;
          await _user.doc(firebaseUser.value?.uid).set({
            "username": username,
            "fullName": fullName,
            "role": "therapist",
            "certificationUrl": certification,
          });
        } else {
          await _user.doc(firebaseUser.value?.uid).set({
            "username": username,
            "fullName": fullName,
            "role": "user",
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      final err = AuthFailure.code(code: e.code);
      print(err.message);
      return err;
    } catch (e) {
      print(e);
      const err = AuthFailure();
      print(err.message);
      return err;
    }
  }

  Future loginUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (firebaseUser.value == null) {
        Get.to(() => const Auth());
      } else {
        if (firebaseUser.value!.displayName == null) {
          Get.offAll(() => const Register(initStep: 1));
        } else {
          firebaseUser.value!.emailVerified ? Get.offAll(() => const Dashboard()) : Get.off(() => const Login(initStep: 1));
        }
      }
    } on FirebaseAuthException catch (e) {
      print("Code : ${e.code}");
      final err = AuthFailure.code(code: e.code, message: "Email or password incorrect");
      print(err.message);
      return err;
    } catch (e) {
      print(e);
      const err = AuthFailure();
      print(err.message);
      return err;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
