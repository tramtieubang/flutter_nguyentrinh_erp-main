import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../session/user_session.dart';

/// =====================================================
/// 🔐 AUTH SERVICE – FINAL VERSION
/// - Không refresh token
/// - Token hết hạn → bắt login lại
/// - Hỗ trợ login vân tay chuẩn
/// =====================================================
class AuthService {
  AuthService._();

  /// 👤 USER TOÀN APP
  static final ValueNotifier<UserModel?> currentUser =
      ValueNotifier<UserModel?>(null);

  // =====================================================
  // 🚀 INIT APP (gọi trong main())
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

      /// TOKEN
      final String token = data['token'] ?? '';
      if (token.isEmpty) return null;

      await LocalStorage.saveToken(token);

      /// USER
      final user = UserModel.fromJson(data['user']);
      currentUser.value = user;
      await LocalStorage.saveUser(user);

      debugPrint('✅ Login password thành công');
      return user;
    } catch (e, s) {
      debugPrint('❌ login error: $e');
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  // =====================================================
  // 🧬 LOGIN BẰNG VÂN TAY (DÙNG TOKEN CŨ)
  // =====================================================
  static Future<bool> loginWithBiometric() async {
  try {
    final token = await LocalStorage.getToken();
    if (token == null || token.isEmpty) return false;

    final response = await ApiClient.get(
      '/auth/me',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) return false;

    final json = jsonDecode(response.body);
    if (json['success'] != true) return false;

    final user = UserModel.fromJson(json['data']);

    /// 🔥🔥🔥 BẮT BUỘC – DÒNG QUAN TRỌNG NHẤT
    UserSession.set(user);

    await LocalStorage.saveUser(user);

    debugPrint('✅ Login vân tay thành công');
    return true;
  } catch (e) {
    debugPrint('❌ loginWithBiometric error: $e');
    return false;
  }
}


  // =====================================================
  // 🔎 VERIFY TOKEN (DÙNG CHO SPLASH)
  // =====================================================
  static Future<bool> verifyToken() async {
    return await loginWithBiometric();
  }

  // =====================================================
  // 🔓 LOGOUT NHẸ (USER CHỦ ĐỘNG)
  // ❗ GIỮ TOKEN + GIỮ BIOMETRIC
  // =====================================================
  static Future<void> logout() async {
    debugPrint('🚪 Logout nhẹ – giữ vân tay');
    currentUser.value = null;
  }

  // =====================================================
  // 🚨 FORCE LOGOUT (TOKEN HẾT HẠN / INVALID)
  // ❗ XOÁ SẠCH + TẮT BIOMETRIC
  // =====================================================
  static Future<void> forceLogout() async {
    debugPrint('🚨 Force logout – token invalid');

    currentUser.value = null;

    await LocalStorage.removeToken();
    await LocalStorage.removeUser();
    await LocalStorage.setBiometric(false);
  }

  // =====================================================
  // 🔁 CHANGE PASSWORD
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
    } catch (e) {
      debugPrint('❌ changePassword error: $e');
      return false;
    }
  }

  // =====================================================
  // 🔁 FORGOT PASSWORD
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
    } catch (e) {
      debugPrint('❌ forgotPassword error: $e');
      return false;
    }
  }

  // =====================================================
  // 👤 GET USER LOCAL
  // =====================================================
  static Future<UserModel?> getCurrentUser() async {
    return await LocalStorage.getUser();
  }

  // =====================================================
  // 🔎 CHECK LOGIN NHẸ (CHỈ CHECK TOKEN)
  // =====================================================
  static Future<bool> isLoggedIn() async {
    final token = await LocalStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  // =====================================================
  // 🔁 RELOAD USER TỪ API (CÓ TOKEN)
  // =====================================================
  static Future<bool> reloadFromApi() async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null || token.isEmpty) return false;

      final response = await ApiClient.get(
        '/auth/me',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) return false;

      final json = jsonDecode(response.body);
      if (json['success'] != true) return false;

      final user = UserModel.fromJson(json['data']);

      currentUser.value = user;
      await LocalStorage.saveUser(user);

      debugPrint('✅ Reload user thành công');
      return true;
    } catch (e) {
      debugPrint('❌ reloadFromApi error: $e');
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
}
