import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _isDarkMode = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isSupervisor => _user?.isSupervisor ?? false;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    _user = await StorageService.getUser();
    _isDarkMode = await StorageService.isDarkMode();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiService.login(username, password);

    _isLoading = false;
    if (result['success'] == true && result['user'] is UserModel) {
      _user = result['user'];
      await StorageService.saveUser(_user!);
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'] ?? 'Login gagal';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    await StorageService.clearUser();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.saveDarkMode(_isDarkMode);
    notifyListeners();
  }
}

