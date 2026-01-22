import 'package:flutter/material.dart';
import 'login_input.dart';
import 'login_button.dart';
import '../forgot_password_screen.dart'; // ✅ IMPORT

class LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController userCtrl;
  final TextEditingController passCtrl;
  final AnimationController shakeCtrl;
  final bool loading;
  final VoidCallback onLogin;

  const LoginCard({
    super.key,
    required this.formKey,
    required this.userCtrl,
    required this.passCtrl,
    required this.shakeCtrl,
    required this.loading,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        decoration: BoxDecoration(          
          color: Colors.white.withAlpha((0.85 * 255).round()), // 0.85 = hơi trong suốt
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

              LoginInput(
                hint: 'Tên đăng nhập',
                icon: Icons.person_outline,
                controller: userCtrl,
              ),

              const SizedBox(height: 22),

              LoginInput(
                hint: 'Mật khẩu',
                icon: Icons.lock_outline,
                controller: passCtrl,
                obscure: true,
              ),

              const SizedBox(height: 10),

              // ✅ FORGOT PASSWORD — ĐÚNG
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
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
              ),

              const SizedBox(height: 24),

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
