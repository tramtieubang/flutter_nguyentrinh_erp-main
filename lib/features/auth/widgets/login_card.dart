import 'package:flutter/material.dart';
import 'login_input.dart';
import 'login_button.dart';
import '../forgot_password_screen.dart';

class LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController userCtrl;
  final TextEditingController passCtrl;
  final AnimationController shakeCtrl;
  final bool loading;
  final VoidCallback onLogin;

  /// 👉 CALLBACK LOGIN BẰNG VÂN TAY / FACE ID
  final VoidCallback onBiometricLogin;

  const LoginCard({
    super.key,
    required this.formKey,
    required this.userCtrl,
    required this.passCtrl,
    required this.shakeCtrl,
    required this.loading,
    required this.onLogin,
    required this.onBiometricLogin,
  });

  @override
  Widget build(BuildContext context) {
    /// Animation rung khi validate lỗi
    final shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(shakeCtrl);

    return AnimatedBuilder(
      animation: shakeAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(shakeAnim.value, 0),
        child: child,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.85 * 255).round()),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),

              /// ===== USERNAME =====
              LoginInput(
                hint: 'Tên đăng nhập',
                icon: Icons.person_outline,
                controller: userCtrl,
              ),

              const SizedBox(height: 22),

              /// ===== PASSWORD =====
              LoginInput(
                hint: 'Mật khẩu',
                icon: Icons.lock_outline,
                controller: passCtrl,
                obscure: true,
              ),

              const SizedBox(height: 12),

              /// =================================================
              /// HÀNG DƯỚI PASSWORD
              /// - Trái: Quên mật khẩu
              /// - Phải: Nút vân tay / Face ID
              /// =================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// 🔹 QUÊN MẬT KHẨU (BÊN TRÁI)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  /// 🔹 LOGIN VÂN TAY / FACE ID (BÊN PHẢI)
                 IconButton(
                    tooltip: 'Đăng nhập bằng vân tay',
                    icon: const Icon(
                      Icons.fingerprint,
                      size: 30,
                      color: Color(0xFF1565C0),
                    ),
                    onPressed: onBiometricLogin, // 👈 mở bottom sheet
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ===== BUTTON LOGIN =====
              LoginButton(
                loading: loading,
                onPressed: onLogin,
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
