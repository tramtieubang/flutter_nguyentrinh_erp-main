import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../events/notification_event.dart';

/// =======================================================
/// 🔔 FirebaseMessagingService
/// - Lắng nghe Firebase Cloud Messaging (FCM)
/// - Chỉ khởi tạo 1 lần duy nhất khi app start
/// =======================================================
class FirebaseMessagingService {
  FirebaseMessagingService._(); // ❌ không cho new

  static bool _initialized = false;

  /// ===================================================
  /// 🚀 Khởi tạo Firebase Messaging
  /// ===================================================
  static Future<void> init() async {
    // ⚠️ Tránh init nhiều lần
    if (_initialized) return;
    _initialized = true;

    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// 🔐 Xin quyền thông báo
    /// - iOS
    /// - Android 13+
    await messaging.requestPermission();

    /// ===============================
    /// 🔔 APP ĐANG MỞ (FOREGROUND)
    /// ===============================
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔔 FCM foreground: ${message.notification?.title}');
      NotificationEvent.notify();
    });

    /// ===============================
    /// 📬 APP NỀN → click thông báo
    /// ===============================
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📬 FCM opened app');
      NotificationEvent.notify();
    });
  }
}
