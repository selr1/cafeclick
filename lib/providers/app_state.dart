import 'package:flutter/material.dart';
import '../mock_data.dart';

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? get currentUser => _currentUser;

  bool login(String username, String password) {
    // mock auth check
    if (username == MockData.adminUser && password == MockData.adminPass) {
      _isLoggedIn = true;
      _currentUser = MockData.userProfile;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
