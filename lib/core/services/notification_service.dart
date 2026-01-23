import 'dart:convert';

import '../models/notification_model.dart';
import '../network/api_client.dart';

class NotificationService {
  NotificationService._();

  static Map<String, dynamic>? _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  /// 📌 LIST
  static Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final res = await ApiClient.get('/notification/list');
      if (res.statusCode != 200) return [];

      final json = _decode(res.body);
      if (json == null || json['success'] != true) return [];

      return (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(NotificationModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// 📌 UNREAD COUNT (QUAN TRỌNG)
  static Future<int> fetchUnreadCount() async {
    try {
      final res = await ApiClient.get('/notification/unread-count');
      if (res.statusCode != 200) return 0;

      final json = _decode(res.body);
      if (json == null || json['success'] != true) return 0;

      return json['data'] is int
          ? json['data']
          : int.tryParse(json['data'].toString()) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// 📌 MARK READ
  static Future<bool> markAsRead(int id) async {
    try {
      final res = await ApiClient.post(
        '/notification/read',
        query: {'id': id.toString()},
      );
      final json = _decode(res.body);
      return json?['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
