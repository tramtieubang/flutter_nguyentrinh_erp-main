import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/biometric_service.dart';
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
  // =====================================================
  // FORM
  // =====================================================
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _loading = false;

  // =====================================================
  // ANIMATION
  // =====================================================
  late final AnimationController _mainCtrl;
  late final AnimationController _shakeCtrl;

  // =====================================================
  // SERVICE
  // =====================================================
  final BiometricService _biometricService = BiometricService();

  // =====================================================
  // INIT
  // =====================================================
  @override
  void initState() {
    super.initState();

    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  // =====================================================
  // 🔑 LOGIN USERNAME / PASSWORD (KHÔNG BẬT BIOMETRIC)
  // =====================================================
  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      _shakeCtrl.forward(from: 0);
      return;
    }

    setState(() => _loading = true);

    final user = await AuthService.login(
      _userCtrl.text.trim(),
      _passCtrl.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (user == null) {
      _showError('Sai tên đăng nhập hoặc mật khẩu');
      return;
    }

    /// ✅ SET SESSION
    UserSession.set(user);

    /// ✅ LƯU USER + TOKEN (AuthService đã lưu token)
    await LocalStorage.saveUser(user);

    /// ❌ TUYỆT ĐỐI KHÔNG bật biometric ở đây

    _goMain();
  }

  // =====================================================
  // 🔐 USER BẤM ICON VÂN TAY (CHỦ ĐỘNG)
  // =====================================================
  Future<void> _loginWithBiometric() async {
    final canCheck = await _biometricService.canCheckBiometric();
    if (!mounted) return;

    if (!canCheck) {
      _showBiometricSettingDialog();
      return;
    }

    final result = await _biometricService.authenticate();
    if (!mounted) return;

    /// ❌ Chưa đăng ký vân tay / FaceID
    if (result == BiometricResult.notAvailable) {
      _showBiometricSettingDialog();
      return;
    }

    /// ❌ Huỷ / fail
    if (result != BiometricResult.success) return;

    /// ✅ LẦN ĐẦU USER ĐỒNG Ý → BẬT BIOMETRIC
    await LocalStorage.setBiometric(true);

    setState(() => _loading = true);

    final success = await AuthService.loginWithBiometric();

    if (!mounted) return;
    setState(() => _loading = false);

    if (!success) {
      _showError('Phiên đăng nhập đã hết hạn');
      await AuthService.logout();
      return;
    }

    _goMain();
  }

  // =====================================================
  // ⚠️ DIALOG HƯỚNG DẪN BẬT SINH TRẮC
  // =====================================================
  void _showBiometricSettingDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Chưa bật sinh trắc học'),
        content: const Text(
          'Thiết bị chưa được thiết lập vân tay hoặc Face ID.\n\n'
          'Vui lòng vào Cài đặt để bật.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Để sau'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppSettings.openAppSettings();
            },
            child: const Text('Mở cài đặt'),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // HELPER
  // =====================================================
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _goMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  // =====================================================
  // DISPOSE
  // =====================================================
  @override
  void dispose() {
    _mainCtrl.dispose();
    _shakeCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // =====================================================
  // UI
  // =====================================================
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
            onBiometricLogin: _loginWithBiometric,
          ),
        ],
      ),
    );
  }
}
