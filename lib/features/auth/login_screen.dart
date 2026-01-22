import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/storage/local_storage.dart';
import '../../core/session/user_session.dart';
import '../main/main_screen.dart';

import 'widgets/login_background.dart';
import 'widgets/login_header.dart';
import 'widgets/login_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _loading = false;

  late AnimationController _mainCtrl;
  late AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _mainCtrl.forward();
  }

  /// ================= LOGIN =================
  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      _shakeCtrl.forward(from: 0);
      return;
    }

    setState(() => _loading = true);

    /// 🔐 CALL API LOGIN
    final user = await AuthService.login(
      _userCtrl.text.trim(),
      _passCtrl.text,
    );

    if (!mounted) return; // ✅ BẮT BUỘC

    setState(() => _loading = false);

    /// ❌ LOGIN FAIL
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sai tên đăng nhập hoặc mật khẩu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    /// ✅ GÁN SESSION TOÀN APP
    UserSession.currentUser.value = user;

    /// ✅ LƯU USER LOCAL (SPLASH + AUTO LOGIN)
    await LocalStorage.saveUser(user);

    if (!mounted) return; // ✅ PHÒNG TRƯỜNG HỢP HIẾM

    /// 🚀 ĐI VÀO MAIN
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _shakeCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginBackground(
      child: Column(
        children: [
          LoginHeader(mainCtrl: _mainCtrl),
          LoginCard(
            formKey: _formKey,
            userCtrl: _userCtrl,
            passCtrl: _passCtrl,
            shakeCtrl: _shakeCtrl,
            loading: _loading,
            onLogin: _login,
          ),
        ],
      ),
    );
  }
}
