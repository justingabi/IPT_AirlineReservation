import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? token;
  String? username;

  void setToken(String? newToken) {
    token = newToken;
    notifyListeners();
  }

  void setUsername(String? newUsername) {
    username = newUsername;
    notifyListeners();
  }
}
