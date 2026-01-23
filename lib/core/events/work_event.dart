import 'dart:async';

class WorkEvent {
  WorkEvent._();

  static final StreamController<void> _reloadController =
      StreamController<void>.broadcast();

  /// Stream reload công việc
  static Stream<void> get reloadStream => _reloadController.stream;

  /// Gọi khi đăng ký / cập nhật công việc xong
  static void notifyReload() {
    _reloadController.add(null);
  }

  static void dispose() {
    _reloadController.close();
  }
}
