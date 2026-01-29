import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/biometric_service.dart';
import '../../core/storage/local_storage.dart';
import '../../config/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final BiometricService _biometricService = BiometricService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  // ===================================================
  // 🔐 CHECK AUTH + BIOMETRIC (CHUẨN)
  // ===================================================
  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    /// 1️⃣ Có token?
    if (!await AuthService.isLoggedIn()) {
      _goLogin();
      return;
    }

    /// 2️⃣ Verify token
    if (!await AuthService.verifyToken()) {
      //await AuthService.logout();
      debugPrint('🚪 Logout nhẹ – giữ vân tay');
      _goLogin();
      return;
    }

    /// 3️⃣ Có bật biometric chưa?
    if (!await LocalStorage.isBiometricEnabled()) {
      _goMain(); // ❗ KHÔNG HỎI VÂN TAY
      return;
    }

    /// 4️⃣ Hỏi vân tay
    final result = await _biometricService.authenticate();
    if (result != BiometricResult.success) {
      _goLogin();
      return;
    }

    /// 5️⃣ Login bằng token
    final ok = await AuthService.loginWithBiometric();
    ok ? _goMain() : _goLogin();
  }

  // ===================================================
  // 🔀 NAVIGATION
  // ===================================================
  void _goMain() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.main);
  }

  void _goLogin() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
