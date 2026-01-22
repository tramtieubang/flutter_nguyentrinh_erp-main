import 'dart:convert';

import '../models/notification_model.dart';
import '../network/api_client.dart';

class NotificationService {
  NotificationService._(); // ❌ không cho new

  /// ===============================
  /// 🔹 Parse JSON an toàn
  /// ===============================
  static Map<String, dynamic>? _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  /// ===============================
  /// 📌 LẤY DANH SÁCH THÔNG BÁO
  /// GET /notification/list
  /// ===============================
  static Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final res = await ApiClient.get('/notification/list');

      if (res.statusCode != 200) return [];

      final json = _decode(res.body);
      if (json == null || json['success'] != true) return [];

      final data = json['data'];
      if (data is! List) return [];

      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// ==================================
  /// 📌 ĐÁNH DẤU 1 THÔNG BÁO ĐÃ ĐỌC
  /// POST /notification/read?id=ID
  /// ==================================
  static Future<bool> markAsRead(int id) async {
    try {
      final res = await ApiClient.post(
        '/notification/read',
        query: {'id': id.toString()},
      );

      if (res.statusCode != 200) return false;

      final json = _decode(res.body);
      return json?['success'] == true;
    } catch (_) {
      return false;
    }
  }

  /// ==================================
  /// 📌 ĐÁNH DẤU TẤT CẢ ĐÃ ĐỌC
  /// POST /notification/read-all
  /// ==================================
  static Future<bool> markAllAsRead() async {
    try {
      final res = await ApiClient.post('/notification/read-all');

      if (res.statusCode != 200) return false;

      final json = _decode(res.body);
      return json?['success'] == true;
    } catch (_) {
      return false;
    }
  }

  /// ==================================
  /// 📌 ĐẾM SỐ THÔNG BÁO CHƯA ĐỌC
  /// GET /notification/unread-count
  /// ==================================
  static Future<int> countUnread() async {
    try {
      final res = await ApiClient.get('/notification/unread-count');

      if (res.statusCode != 200) return 0;

      final json = _decode(res.body);
      if (json == null || json['success'] != true) return 0;

      final data = json['data'];

      if (data is int) return data;
      if (data is String) return int.tryParse(data) ?? 0;

      return 0;
    } catch (_) {
      return 0;
    }
  }

  /// ==================================
  /// 🔥 REFRESH TOÀN BỘ (badge + list)
  /// ==================================
  static Future<NotificationSummary> refresh() async {
    final results = await Future.wait([
      fetchNotifications(),
      countUnread(),
    ]);

    return NotificationSummary(
      notifications: results[0] as List<NotificationModel>,
      unreadCount: results[1] as int,
    );
  }
}

/// ===============================
/// MODEL GỘP (OPTIONAL)
/// ===============================
class NotificationSummary {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationSummary({
    required this.notifications,
    required this.unreadCount,
  });
}
