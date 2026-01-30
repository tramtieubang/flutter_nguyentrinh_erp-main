import 'package:flutter/material.dart';

import '../../config/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _decideRoute();
    });
  }

  // ===================================================
  // 🚦 SPLASH CHỈ QUYẾT ĐỊNH:
  // - Login
  // - KHÔNG vào Main
  // ===================================================
  Future<void> _decideRoute() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    /// ❗ DÙ CÓ TOKEN HAY KHÔNG → ĐỀU VÀO LOGIN
    /// LoginScreen sẽ:
    /// - hỏi vân tay
    /// - hoặc cho nhập mật khẩu
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
