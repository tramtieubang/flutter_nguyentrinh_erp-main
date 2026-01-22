import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app.dart'; // Home screen (WorkScreen)
import 'core/services/auth_service.dart';
import 'core/services/work_assignment_service.dart';
import 'core/models/work_assignment_model.dart';
import 'features/work/work_detail_screen.dart';
import 'features/auth/login_screen.dart';

/// 🔹 Navigator global
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 🔹 Background handler (KHÔNG UI)
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// 🔹 Xử lý notification, push chi tiết hoặc yêu cầu login
void _handleNotification(RemoteMessage message) {
  final navigator = navigatorKey.currentState;
  if (navigator == null) return;

  final Map<String, dynamic> data = message.data;
  final int? workId = int.tryParse(data['work_id']?.toString() ?? '');
  if (workId == null) return;

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // 🔹 Kiểm tra login
    final bool loggedIn = await AuthService.isLoggedIn();
    if (!loggedIn) {
      navigator.push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    try {
      // 🔹 Lấy chi tiết công việc từ API
      final WorkAssignmentModel work =
          await WorkAssignmentService.getWorkDetail(workId);

      if (!navigator.mounted) return;

      // 🔹 Push màn hình chi tiết
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
      debugPrint('❌ Lấy chi tiết thất bại: $e');
      debugPrintStack(stackTrace: s);
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🔹 Background FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // 🔹 App đang mở
  FirebaseMessaging.onMessage.listen(_handleNotification);

  runApp(const MyAppWrapper());
}

/// ===============================
/// 🔹 Wrapper App
/// ===============================
class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  State<MyAppWrapper> createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  @override
  void initState() {
    super.initState();

    // 🔹 App bị kill → mở bằng notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) _handleNotification(message);
    });

    // 🔹 App background → mở bằng notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Work App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyApp(), // Your WorkScreen
      onGenerateRoute: (settings) {
        if (settings.name == '/workdetailscreen') {
          final Map<String, String> data =
              Map<String, String>.from(settings.arguments as Map);

          return MaterialPageRoute(
            builder: (_) => WorkDetailScreen(
              title: data['title'] ?? '',
              startDate: data['start_date'] ?? '',
              endDate: data['end_date'] ?? '',
              description: data['description'] ?? '',
            ),
          );
        }
        return null;
      },
    );
  }
}
