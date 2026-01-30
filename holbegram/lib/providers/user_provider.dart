import 'package:flutter/material.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Users? _user;
  final AuthMethode _authMethods = AuthMethode();

  Users? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      debugPrint("refreshUser() called");
      final user = await _authMethods.getUserDetails();
      _user = user;
      debugPrint("refreshUser() ok: ${_user?.uid}");
      notifyListeners();
    } catch (e) {
      debugPrint("refreshUser() error: $e");
    }
  }
}
