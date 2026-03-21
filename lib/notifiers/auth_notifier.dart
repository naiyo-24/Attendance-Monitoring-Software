import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthNotifier extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Simulate login delay
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@admin.com' && password == 'admin123') {
      _user = User(email: email, password: password);
      _isLoading = false;
      notifyListeners();
    } else {
      _error = 'Invalid credentials';
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
