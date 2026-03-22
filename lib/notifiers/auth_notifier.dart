import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class AuthNotifier extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  final AuthService _authService = AuthService();

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _authService.login(email, password);
      _user = user;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
