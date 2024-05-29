import 'package:flutter/material.dart';
import 'package:instaclone/models/user.dart';
import 'package:instaclone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final Authmethods _authmethods = Authmethods();

  User? get getter => _user;
  Future<void> refreshuser() async {
    User user = await _authmethods.getuserdetails();
    _user = user;
    notifyListeners();
  }
}
