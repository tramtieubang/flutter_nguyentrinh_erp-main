import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';

class AuthService {
  /// =====================================================
  /// 🔥 USER TOÀN CỤC
  /// - Toàn bộ app (HomeHeader, Profile, Drawer...)
  /// - Chỉ nghe 1 nguồn duy nhất
  /// =====================================================
  static final ValueNotifier<UserModel?> currentUser =
      ValueNotifier<UserModel?>(null);

  /// =====================================================
  /// 🔐 VERIFY TOKEN (DÙNG CHO SPLASH)
  /// - Kiểm tra token còn hợp lệ không
  /// - Nếu hợp lệ → set currentUser
  /// =====================================================
  static Future<bool> verifyToken() async {
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

      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] != true) return false;

      /// 🔥 parse user
      final user = UserModel.fromJson(jsonData['data']);

      /// 🔥 lưu + bắn notifier
      currentUser.value = user;
      await LocalStorage.saveUser(user);

      return true;
    } catch (e) {
      debugPrint('verifyToken error: $e');
      return false;
    }
  }

  /// =====================================================
  /// 🔑 LOGIN
  /// - Lưu token
  /// - Lưu user
  /// - Set currentUser
  /// =====================================================
  static Future<UserModel?> login(String username, String password) async {
    try {
      final response = await ApiClient.post(
        '/auth/login',
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode != 200) return null;

      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] != true) return null;

      final data = jsonData['data'];

      /// 🔐 TOKEN
      final token = data['token'];
      if (token == null || token.toString().isEmpty) return null;
      await LocalStorage.saveToken(token);

      /// 👤 USER
      final userJson = data['user'];
      if (userJson == null) return null;

      final user = UserModel.fromJson(userJson);

      /// 🔥 LƯU + SET USER TOÀN APP
      await LocalStorage.saveUser(user);
      currentUser.value = user;

      return user;
    } catch (e) {
      debugPrint('login error: $e');
      return null;
    }
  }

  /// =====================================================
  /// 🔄 INIT APP
  /// - Gọi khi app khởi động
  /// =====================================================
  static Future<void> init() async {
    final user = await LocalStorage.getUser();
    currentUser.value = user;
  }

  /// =====================================================
  /// 🔓 LOGOUT
  /// =====================================================
  static Future<void> logout() async {
    currentUser.value = null;
    await LocalStorage.clearAll();
  }

  /// =====================================================
  /// 🔎 CHECK LOGIN (NHẸ – KHÔNG GỌI API)
  /// =====================================================
  static Future<bool> isLoggedIn() async {
    final token = await LocalStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// =====================================================
  /// 🔁 CHANGE PASSWORD
  /// =====================================================
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

      final jsonData = jsonDecode(response.body);
      return jsonData['success'] == true;
    } catch (e) {
      debugPrint('changePassword exception: $e');
      return false;
    }
  }

    /// =====================================================
  /// 🔄 UPDATE USER SAU KHI SỬA PROFILE
  /// - Gọi sau khi update avatar / name / info
  /// - Reload toàn bộ UI đang listen currentUser
  /// =====================================================
  static Future<void> updateCurrentUser(UserModel user) async {
    /// 🔥 set lại notifier (Home, Header, Drawer reload)
    currentUser.value = user;

    /// 🔥 lưu xuống local để Splash / mở app lại dùng
    await LocalStorage.saveUser(user);
  }

  /// =====================================================
  /// 👤 GET CURRENT USER (TỪ LOCAL STORAGE)
  /// - Dùng cho reload session
  /// - Không gọi API
  /// =====================================================
  static Future<UserModel?> getCurrentUser() async {
    try {
      final user = await LocalStorage.getUser();
      return user;
    } catch (e) {
      debugPrint('getCurrentUser error: $e');
      return null;
    }
  }

  // =====================================================
  /// 🔁 FORGOT PASSWORD
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

      if (response.statusCode != 200) {
        debugPrint('forgotPassword failed: ${response.statusCode}');
        return false;
      }

      final jsonData = jsonDecode(response.body);

      return jsonData['success'] == true;
    } catch (e) {
      debugPrint('forgotPassword exception: $e');
      return false;
    }
  }

  static Future<bool> reloadFromApi() async {
    try {
      final response = await ApiClient.get('/auth/me');

      if (response.statusCode != 200) return false;

      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] != true) return false;

      final user = UserModel.fromJson(jsonData['data']);

      /// 🔥 CẬP NHẬT TOÀN BỘ APP
      currentUser.value = user;
      await LocalStorage.saveUser(user);

      debugPrint('✅ Reload from API: ${user.toJson()}');
      return true;
    } catch (e) {
      debugPrint('❌ reloadFromApi error: $e');
      return false;
    }
  }


}
