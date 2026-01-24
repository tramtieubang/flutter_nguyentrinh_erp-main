import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

/// =======================================================
/// 👤 USER SESSION
/// - Lưu thông tin user đang đăng nhập
/// - Dùng ValueNotifier để toàn bộ app lắng nghe thay đổi
/// - Khi user thay đổi → UI tự rebuild
/// =======================================================
class UserSession {
  /// 🔔 User hiện tại của app
  /// HomeScreen, Drawer, Header... đều lắng nghe biến này
  static final ValueNotifier<UserModel?> currentUser =
      ValueNotifier<UserModel?>(null);

  /// ===================================================
  /// ✅ Gán user khi đăng nhập thành công
  /// ===================================================
  static void set(UserModel user) {
    currentUser.value = user; // 🔥 trigger rebuild toàn app
  }

  /// ===================================================
  /// 🔄 Reload user từ API
  /// 👉 GỌI SAU KHI:
  /// - Update profile
  /// - Upload avatar
  /// - Cập nhật thông tin cá nhân
  /// ===================================================
  static Future<void> reload() async {
    try {
      final user = await AuthService.getCurrentUser();

      debugPrint('🔁 Reload user: ${user?.toJson()}');

      if (user != null) {
        currentUser.value = user; // 🔥 bắt buộc gán object MỚI
      }
    } catch (e) {
      debugPrint('❌ UserSession.reload error: $e');
    }
  }

  /// ===================================================
  /// 🚪 Xóa session khi đăng xuất
  /// ===================================================
  static void clear() {
    currentUser.value = null;
  }
}
