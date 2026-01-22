import 'dart:convert';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  bool isRead; // ⚠️ KHÔNG final – cho phép cập nhật UI
  final String createdAt;
  final Map<String, dynamic> data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      isRead: _parseBool(json['is_read']),
      createdAt: json['created_at']?.toString() ?? '',
      data: _parseData(json['data']),
    );
  }

  /// ===============================
  /// 🔹 Parse int an toàn
  /// ===============================
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// ===============================
  /// 🔹 Parse bool an toàn (0/1/true/false)
  /// ===============================
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }
    return false;
  }

  /// ===============================
  /// 🔹 Parse data an toàn
  /// ===============================
  static Map<String, dynamic> _parseData(dynamic value) {
    if (value == null) return {};

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {}
    }

    return {};
  }
}
