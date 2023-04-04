// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

import '../models/role.dart';

class LocalDB {
  static late SharedPreferences _store;

  static init() async {
    _store = await SharedPreferences.getInstance();
  }

  static saveUserRole(int role) async {
    _store.setInt("role", role).then((value) => null);
  }
  static removeUserRole() async {
    _store.remove("role").then((value) => null);
  }

  static Role? getUserRole() {
    int? role = _store.getInt("role");
    if (role != null) {
      return role == 0 ? Role.user : Role.therapist;
    }
    return null;
  }
}
