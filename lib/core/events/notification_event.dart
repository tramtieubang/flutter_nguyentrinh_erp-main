import 'dart:async';

class NotificationEvent {
  NotificationEvent._();

  /// 🔔 Badge unread
  static final StreamController<int> _unreadController =
      StreamController<int>.broadcast();

  /// 🔄 Reload notification list
  static final StreamController<void> _reloadController =
      StreamController<void>.broadcast();

  /// ===== STREAM =====
  static Stream<int> get unreadStream => _unreadController.stream;
  static Stream<void> get reloadStream => _reloadController.stream;

  /// ===== EMIT =====

  /// Cập nhật số thông báo chưa đọc
  static void updateUnread(int count) {
    _unreadController.add(count);
  }

  /// Trigger reload danh sách
  static void notify() {
    _reloadController.add(null);
  }

  static void dispose() {
    _unreadController.close();
    _reloadController.close();
  }
}
