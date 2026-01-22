import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
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
      _checkAuth();
    });
  }

  /// ================= CHECK AUTH =================
  Future<void> _checkAuth() async {
    // ⏳ delay nhẹ cho splash mượt
    await Future.delayed(const Duration(milliseconds: 600));

    /// 🔐 verify token + khôi phục user
    final isValid = await AuthService.verifyToken();
    if (!mounted) return;

    if (isValid) {
      _goMain();
    } else {
      await AuthService.logout();
      _goLogin();
    }
  }

  void _goMain() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.main);
  }

  void _goLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.login);
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
