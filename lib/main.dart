import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app.dart';
import 'core/app_keys.dart';
import 'core/services/auth_service.dart';
import 'core/session/user_session.dart';
import 'core/services/work_assignment_service.dart';
import 'core/models/work_assignment_model.dart';
import 'features/work/work_detail_screen.dart';
import 'features/auth/login_screen.dart';

/// =======================================================
/// 🔹 FCM BACKGROUND HANDLER (KHÔNG UI)
/// =======================================================
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// =======================================================
/// 🔹 XỬ LÝ CLICK NOTIFICATION
/// =======================================================
void _handleNotification(RemoteMessage message) {
  final navigator = navigatorKey.currentState;
  if (navigator == null) return;

  final data = message.data;
  final int? workId = int.tryParse(data['work_id']?.toString() ?? '');
  if (workId == null) return;

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    /// 🔹 LẤY USER TỪ LOCAL (KHÔNG VERIFY TOKEN Ở ĐÂY)
    final user = await AuthService.getCurrentUser();

    /// ❌ CHƯA LOGIN → LOGIN
    if (user == null) {
      navigator.push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    /// ✅ SET SESSION (BẮT BUỘC CHO API)
    UserSession.set(user);

    try {
      final WorkAssignmentModel work =
          await WorkAssignmentService.getWorkDetail(workId);

      if (!navigator.mounted) return;

      navigator.push(
        MaterialPageRoute(
          builder: (_) => WorkDetailScreen(
            title: work.title,
            startDate: work.startDate,
            endDate: work.endDate,
            description: work.description,
          ),
        ),
      );
    } catch (e, s) {
      debugPrint('❌ Notification error: $e');
      debugPrintStack(stackTrace: s);
    }
  });
}

/// =======================================================
/// 🔹 MAIN
/// =======================================================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// 🔹 FCM BACKGROUND
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  /// 🔹 XIN QUYỀN NOTIFICATION
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  /// 🔹 APP ĐANG MỞ
  FirebaseMessaging.onMessage.listen(_handleNotification);

  runApp(const MyAppWrapper());
}

/// =======================================================
/// 🔹 APP WRAPPER
/// =======================================================
class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  State<MyAppWrapper> createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initNotification();
  }

  Future<void> _initNotification() async {
    /// 🔹 APP MỞ TỪ NOTIFICATION (KHI BỊ KILL)
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _handleNotification(message);
    }

    /// 🔹 APP BACKGROUND → CLICK NOTIFICATION
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Colors.orange),
          ),
        ),
      );
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      debugShowCheckedModeBanner: false,
      home: const MyApp(), // 👉 MyApp chứa SplashScreen
    );
  }
}
