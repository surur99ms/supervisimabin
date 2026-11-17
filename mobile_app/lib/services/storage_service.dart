import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_constants.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _keyUser = 'auth_user';
  static const String _keyPeriod = 'active_period';
  static const String _keyApiUrl = 'api_base_url';
  static const String _keyDarkMode = 'dark_mode';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyUser);
    if (data == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }

  static Future<void> saveActivePeriod(String period) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPeriod, period);
  }

  static Future<String> getActivePeriod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPeriod) ?? AppConstants.defaultPeriod;
  }

  static Future<void> saveApiUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApiUrl, url);
  }

  static Future<String> getApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyApiUrl) ?? AppConstants.defaultLocalUrl;
  }

  static Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }
}

