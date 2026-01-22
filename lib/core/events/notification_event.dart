import 'package:flutter/material.dart';

/// =======================================================
/// 🔔 NotificationEvent
/// - Dùng để phát sự kiện khi:
///   + Có thông báo mới (FCM)
///   + Đọc 1 thông báo
///   + Đọc tất cả thông báo
///
/// - Các màn hình chỉ cần lắng nghe:
///   NotificationEvent.refresh.addListener(...)
/// =======================================================
class NotificationEvent {
  NotificationEvent._(); // ❌ không cho new

  /// ValueNotifier dùng làm "event bus"
  /// Chỉ cần thay đổi value là tất cả listener được gọi
  static final ValueNotifier<int> refresh = ValueNotifier<int>(0);

  /// ===================================================
  /// 🔥 Phát sự kiện thông báo
  /// ===================================================
  static void notify() {
    // Tăng value để trigger listener
    refresh.value++;
  }
}
