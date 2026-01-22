import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserSession {
  static final ValueNotifier<UserModel?> currentUser =
      ValueNotifier<UserModel?>(null);

  static void set(UserModel user) {
    currentUser.value = user;
  }

  /// 🔥 GỌI SAU KHI UPDATE PROFILE
  static Future<void> reload() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      currentUser.value = user;
    }
  }

  static void clear() {
    currentUser.value = null;
  }
}
