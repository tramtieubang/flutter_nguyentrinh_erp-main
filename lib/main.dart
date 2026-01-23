import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app.dart';
import 'core/services/auth_service.dart';
import 'core/session/user_session.dart';
import 'core/services/work_assignment_service.dart';
import 'core/models/work_assignment_model.dart';
import 'features/work/work_detail_screen.dart';
import 'features/auth/login_screen.dart';

/// 🔹 Navigator global (dùng cho notification)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// =======================================================
/// 🔹 FCM background handler (KHÔNG UI)
/// =======================================================
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// =======================================================
/// 🔹 Xử lý khi click notification
/// - Nếu CHƯA login → mở Login
/// - Nếu ĐÃ login → mở chi tiết công việc
/// =======================================================
void _handleNotification(RemoteMessage message) {
  final navigator = navigatorKey.currentState;
  if (navigator == null) return;

  final data = message.data;
  final int? workId = int.tryParse(data['work_id']?.toString() ?? '');
  if (workId == null) return;

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    /// 🔥 LẤY USER HIỆN TẠI
    final user = await AuthService.getCurrentUser();

    /// ❌ CHƯA LOGIN → ĐẨY VỀ LOGIN
    if (user == null) {
      navigator.push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    /// ✅ ĐÃ LOGIN → SET SESSION (CỰC KỲ QUAN TRỌNG)
    UserSession.set(user);

    try {
      /// 🔹 Gọi API lấy chi tiết công việc
      final WorkAssignmentModel work =
          await WorkAssignmentService.getWorkDetail(workId);

      if (!navigator.mounted) return;

      /// 🔹 Push màn hình chi tiết
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
      debugPrint('❌ Lỗi lấy chi tiết công việc: $e');
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

  /// 🔥 LOAD USER ĐÃ LOGIN (FIX LỖI HOME TRẮNG)
  final user = await AuthService.getCurrentUser();
  if (user != null) {
    UserSession.set(user);
  }

  /// 🔹 FCM background
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  /// 🔹 Xin quyền notification
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  /// 🔹 App đang mở
  FirebaseMessaging.onMessage.listen(_handleNotification);

  runApp(const MyAppWrapper());
}

/// =======================================================
/// 🔹 APP WRAPPER
/// - Bắt notification khi app:
///   + bị kill
///   + chạy background
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
    _initApp();
  }

  Future<void> _initApp() async {
    /// 🔥 LOAD USER TRƯỚC
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      UserSession.set(user);
    }

    /// 🔹 App mở từ notification khi bị kill
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _handleNotification(message);
    }

    /// 🔹 App background → click notification
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
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
    );
  }
}
