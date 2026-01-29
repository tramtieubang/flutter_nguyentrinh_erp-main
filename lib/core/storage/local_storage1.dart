import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/profile_model.dart';

class LocalStorage {
  LocalStorage._();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  static const _profileKey = 'profile';
  static const _bioKey = 'biometric_enabled';

  /// ================= TOKEN =================
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token.trim());
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.trim().isEmpty) return null;
    return token;
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// ================= USER =================
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null || data.trim().isEmpty) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  /// ================= PROFILE =================
  static Future<void> saveProfile(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  static Future<ProfileModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_profileKey);
    if (data == null || data.trim().isEmpty) return null;
    return ProfileModel.fromJson(jsonDecode(data));
  }

  /// ================= BIOMETRIC =================
  static Future<void> setBiometric(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bioKey, value);
  }

  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_bioKey) ?? false;
  }

  /// ================= AUTO LOGIN CHECK =================
  /// Có đủ dữ liệu để auto login bằng vân tay không?
  static Future<bool> canAutoLogin() async {
    final token = await getToken();
    final enabled = await isBiometricEnabled();
    return token != null && enabled;
  }

  /// ================= LOGOUT (GIỮ VÂN TAY) =================
  static Future<void> clearLoginOnly() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_profileKey);
    // ❗ KHÔNG xoá biometric
  }

  /// ================= RESET APP =================
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
