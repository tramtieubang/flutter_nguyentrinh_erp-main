import 'package:flutter/material.dart';
import 'widgets/change_password_appbar.dart';
import 'widgets/password_form_card.dart';
import '../../../core/services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _oldObscure = true;
  bool _newObscure = true;
  bool _confirmObscure = true;

  bool _loading = false;

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  /// Submit đổi mật khẩu
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final oldPassword = _oldPassCtrl.text.trim();
    final newPassword = _newPassCtrl.text.trim();

    final success = await AuthService.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: _confirmCtrl.text.trim(),
    );

    if (!mounted) return; // <--- tránh lỗi dùng context sau async

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Đổi mật khẩu thành công' : 'Đổi mật khẩu thất bại. Vui lòng thử lại',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      Navigator.pop(context); // quay lại màn hình trước
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const ChangePasswordAppBar(),
                const SizedBox(height: 40),
                PasswordFormCard(
                  formKey: _formKey,
                  oldPassCtrl: _oldPassCtrl,
                  newPassCtrl: _newPassCtrl,
                  confirmCtrl: _confirmCtrl,
                  oldObscure: _oldObscure,
                  newObscure: _newObscure,
                  confirmObscure: _confirmObscure,
                  toggleOld: () =>
                      setState(() => _oldObscure = !_oldObscure),
                  toggleNew: () =>
                      setState(() => _newObscure = !_newObscure),
                  toggleConfirm: () =>
                      setState(() => _confirmObscure = !_confirmObscure),
                  onSubmit: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
      // ===== Loading overlay =====
      if (_loading)
        Container(
          color: Colors.black38,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.orangeAccent),
          ),
       ),
      ]
    ),
    );
  }
}
