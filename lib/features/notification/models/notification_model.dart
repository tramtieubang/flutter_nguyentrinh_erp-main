import 'dart:convert';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final Map<String, dynamic> data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      isRead: json['is_read'] == 1,
      data: json['data'] != null ? jsonDecode(json['data']) : {},
    );
  }
}