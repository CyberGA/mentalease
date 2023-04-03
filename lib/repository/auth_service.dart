// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mentalease/firebase.dart';
import 'package:mentalease/models/role.dart';
import 'package:mentalease/module/hash.dart';
import 'package:mentalease/repository/exceptions/auth.dart';
import 'package:mentalease/shared/popup.dart';
import 'package:mentalease/views/auth/index.dart';
import 'package:mentalease/views/auth/login/index.dart';
import 'package:mentalease/views/auth/register/index.dart';
import 'package:mentalease/views/dashboard/index.dart';

class AuthService extends GetxController {
  static AuthService get instance => Get.find();

  // variables
  final _auth = fAuth;
  final _storage = fStorage;
  final CollectionReference _user = usersCollection;
  final CollectionReference _therapist = therapistsCollection;

  late final Rx<User?> firebaseUser;

  //* Set up the first screen
  _setInitialScreen(User? user) {
    Future.delayed(const Duration(seconds: 2), () {
      if (user == null) {
        Get.offAll(() => const Auth());
      } else {
        if (user.emailVerified) {
          Get.offAll(() => const Dashboard());
        } else if (Get.currentRoute == "/onboarding") {
          sendVerification().then((res) {
            if (res is AuthFailure) {
              return popup(text: "${res.message}. Please restart the application", type: Notify.error, title: "Error");
            }
            Get.offAll(() => const Login(initStep: 1));
          });
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
      final err = AuthFailure.code(code: e.code);
      return err;
    } catch (e) {
      const err = AuthFailure();
      return err;
    }
  }

  Future sendVerification() async {
    try {
      await firebaseUser.value?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final err = AuthFailure.code(code: e.code);
      return err;
    } catch (e) {
      const err = AuthFailure();
      return err;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.offAll(() => const Login());
    } on FirebaseAuthException catch (e) {
      final err = AuthFailure.code(code: e.code);
      return err;
    } catch (e) {
      const err = AuthFailure();
      return err;
    }
  }

  // check if user already exists
  Future userAlreadyExists(CollectionReference user, String username) async {
    final QuerySnapshot res = await user.where("username", isEqualTo: username).get();
    if (res.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future completeProfile(String username, String email, String certPath, File? certFile, String picsPath, File pics, Role role, String fullName) async {
    final String certification;
    final String photo;
    try {
      final user = role == Role.therapist ? _therapist : _user;
      final docId = Crypto.hash(email);
      final bool userExists = await userAlreadyExists(user, username);
      if (userExists) {
        return AuthFailure.code(code: "username-already-exits");
      }

      if (firebaseUser.value != null) {
        final picsRef = _storage.ref().child(picsPath);
        await picsRef.putFile(pics);
        photo = await picsRef.getDownloadURL();
        await firebaseUser.value?.updateDisplayName(username);

        if (certFile != null && role == Role.therapist) {
          final certRef = _storage.ref().child(certPath);
          await certRef.putFile(certFile);
          certification = await certRef.getDownloadURL();

          await _therapist.doc(docId).set({
            "id": firebaseUser.value?.uid,
            "username": username,
            "fullName": fullName,
            "role": "therapist",
            "certificationUrl": certification,
            "photo": photo,
            "verified": firebaseUser.value?.emailVerified,
          });
        } else {
          await _user.doc(docId).set({
            "id": firebaseUser.value?.uid,
            "username": username,
            "fullName": fullName,
            "role": "user",
            "photo": photo,
            "verified": firebaseUser.value?.emailVerified,
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      final err = AuthFailure.code(code: e.code);
      return err;
    } catch (e) {
      const err = AuthFailure();
      return err;
    }
  }

  Future updateVerificationStatus(Role role) async {
    final user = firebaseUser.value;
    CollectionReference store = role == Role.therapist ? _therapist : _user;
    if (user != null) {
      try {
        await user.reload();
        final docId = Crypto.hash(user.email!);
        final res = await store.doc(docId).get();
        if (res.exists) {
          await store.doc(docId).update({"verified": true});
        }
        return true;
      } on FirebaseAuthException catch (e) {
        final err = AuthFailure.code(code: e.code, message: "Email or password incorrect");
        return err;
      } catch (e) {
        const err = AuthFailure();
        return err;
      }
    }
  }

  Future checkUser(Role role, String email) async {
    final user = role == Role.therapist ? _therapist : _user;
    final docId = Crypto.hash(email);
    final res = await user.doc(docId).get();

    if (res.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future loginUserWithEmailAndPassword(String email, String password, Role role) async {
    try {
      final isCorrectUser = await checkUser(role, email);
      if (isCorrectUser) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        if (firebaseUser.value!.displayName == null) {
          Get.offAll(() => const Register(initStep: 1));
        } else {
          firebaseUser.value!.emailVerified ? Get.offAll(() => const Dashboard()) : Get.off(() => const Login(initStep: 1));
        }
      } else {
        return AuthFailure.code(code: "incorrect-user-role");
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
