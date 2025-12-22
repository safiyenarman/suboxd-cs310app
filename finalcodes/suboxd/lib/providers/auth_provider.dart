import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
//test3
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? user;
  bool loading = true;

  AuthProvider() {
    _authService.authStateChanges().listen((u) {
      user = u;
      loading = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> register(String email, String password) async {
    await _authService.signUp(email, password);
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}