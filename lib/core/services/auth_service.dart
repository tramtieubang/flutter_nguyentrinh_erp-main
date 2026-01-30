import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../session/user_session.dart';

class AuthService {
  AuthService._();

  /// 👤 USER TOÀN APP
  static final ValueNotifier<UserModel?> currentUser =
      ValueNotifier<UserModel?>(null);

  // =====================================================
  // 🚀 INIT APP (gọi trong main)
  // =====================================================
  static Future<void> init() async {
    final user = await LocalStorage.getUser();
    currentUser.value = user;
  }

  // =====================================================
  // 🔐 LOGIN USERNAME / PASSWORD
  // =====================================================
  static Future<UserModel?> login(
    String username,
    String password,
  ) async {
    try {
      final response = await ApiClient.post(
        '/auth/login',
        body: {
          'username': username.trim(),
          'password': password,
        },
      );

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body);
      if (json['success'] != true) return null;

      final data = json['data'];
      final token = data['token'] ?? '';
      if (token.isEmpty) return null;

      await LocalStorage.saveToken(token);

      final user = UserModel.fromJson(data['user']);
      currentUser.value = user;
      UserSession.set(user);
      await LocalStorage.saveUser(user);

      debugPrint('✅ Login password OK');
      return user;
    } catch (e, s) {
      debugPrint('❌ login error: $e');
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  // =====================================================
  // 🧬 LOGIN VÂN TAY (DÙNG TOKEN)
  // =====================================================
  static Future<bool> loginWithBiometric() async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null || token.isEmpty) return false;

      /// ❌ KHÔNG setToken – ApiClient tự đọc LocalStorage
      final response = await ApiClient.get('/auth/me');

      if (response.statusCode != 200) return false;

      final json = jsonDecode(response.body);
      if (json['success'] != true) return false;

      final user = UserModel.fromJson(json['data']);

      currentUser.value = user;
      UserSession.set(user);
      await LocalStorage.saveUser(user);

      debugPrint('✅ Login vân tay OK');
      return true;
    } catch (e) {
      debugPrint('❌ loginWithBiometric error: $e');
      return false;
    }
  }

  // =====================================================
  // 🔎 VERIFY TOKEN (CHO SPLASH)
  // =====================================================
  static Future<bool> verifyToken() async {
    return await loginWithBiometric();
  }

  // =====================================================
  // 🔓 LOGOUT NHẸ (TRONG APP)
  // =====================================================
  static Future<void> logout() async {
    debugPrint('🚪 Logout nhẹ');

    currentUser.value = null;
    UserSession.clear();

    /// ❗ KHÔNG xoá token
    /// → nếu đóng app, session mất → Splash sẽ hỏi lại
  }

  // =====================================================
  // 🚨 FORCE LOGOUT (TOKEN INVALID / 401)
  // =====================================================
  static Future<void> forceLogout() async {
    debugPrint('🚨 Force logout');

    currentUser.value = null;
    UserSession.clear();

    await LocalStorage.removeToken();
    await LocalStorage.removeUser();
    await LocalStorage.setBiometric(false);
  }

  // =====================================================
  // 🔎 CHECK LOGIN (SPLASH)
  // =====================================================
  static Future<bool> isLoggedIn() async {
    final token = await LocalStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  // =====================================================
  // 👤 GET USER LOCAL
  // =====================================================
  static Future<UserModel?> getCurrentUser() async {
    return await LocalStorage.getUser();
  }

  // =====================================================
  // 🔁 RELOAD USER
  // =====================================================
  static Future<bool> reloadFromApi() async {
    try {
      final response = await ApiClient.get('/auth/me');
      if (response.statusCode != 200) return false;

      final json = jsonDecode(response.body);
      if (json['success'] != true) return false;

      final user = UserModel.fromJson(json['data']);
      currentUser.value = user;
      UserSession.set(user);
      await LocalStorage.saveUser(user);

      return true;
    } catch (_) {
      return false;
    }
  }

  // =====================================================
  // 🔁 UPDATE USER LOCAL
  // =====================================================
  static Future<void> updateCurrentUser(UserModel user) async {
    currentUser.value = user;
    await LocalStorage.saveUser(user);
  }

  //===================================================== 
  // 🔁 FORGOT PASSWORD 
  // =====================================================
  // =====================================================
// 🔁 FORGOT PASSWORD (KHÔNG CẦN LOGIN)
// =====================================================
  static Future<bool> forgotPassword({
    required String email,
    }) async {
      try {
        final response = await ApiClient.post(
          '/auth/forgot-password',
          body: {
            'email': email.trim(),
          },
        );

        if (response.statusCode != 200) return false;

        final json = jsonDecode(response.body);
        return json['success'] == true;
      } catch (e, s) {
        debugPrint('❌ forgotPassword error: $e');
        debugPrintStack(stackTrace: s);
        return false;
      }
    }

  // =====================================================
  // 🔁 CHANGE PASSWORD (CẦN LOGIN)
  // =====================================================
  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null || token.isEmpty) return false;

      final response = await ApiClient.post(
        '/auth/change-password',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );

      if (response.statusCode != 200) return false;

      final json = jsonDecode(response.body);
      return json['success'] == true;
    } catch (e, s) {
      debugPrint('❌ changePassword error: $e');
      debugPrintStack(stackTrace: s);
      return false;
    }
  }



}
