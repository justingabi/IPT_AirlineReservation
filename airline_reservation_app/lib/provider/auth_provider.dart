import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;
  String? username;

  void setToken(String? newToken) {
    _token = newToken;
    notifyListeners();
  }

  void setUsername(String? newUsername) {
    username = newUsername;
    notifyListeners();
  }
}
