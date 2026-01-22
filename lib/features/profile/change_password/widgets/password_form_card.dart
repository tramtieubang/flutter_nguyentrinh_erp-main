import 'package:flutter/material.dart';
import 'password_field.dart';

class PasswordFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController oldPassCtrl;
  final TextEditingController newPassCtrl;
  final TextEditingController confirmCtrl;

  final bool oldObscure;
  final bool newObscure;
  final bool confirmObscure;

  final VoidCallback toggleOld;
  final VoidCallback toggleNew;
  final VoidCallback toggleConfirm;
  final VoidCallback onSubmit;

  const PasswordFormCard({
    super.key,
    required this.formKey,
    required this.oldPassCtrl,
    required this.newPassCtrl,
    required this.confirmCtrl,
    required this.oldObscure,
    required this.newObscure,
    required this.confirmObscure,
    required this.toggleOld,
    required this.toggleNew,
    required this.toggleConfirm,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.9 * 255).round()),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 15),
            PasswordField(
              label: 'Mật khẩu hiện tại',
              controller: oldPassCtrl,
              obscure: oldObscure,
              onToggle: toggleOld,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Không được để trống' : null,
            ),
            const SizedBox(height: 18),
            PasswordField(
              label: 'Mật khẩu mới',
              controller: newPassCtrl,
              obscure: newObscure,
              onToggle: toggleNew,
              validator: (v) =>
                   v == null || v.isEmpty ? 'Không được để trống' : null,
            ),
            const SizedBox(height: 18),
            PasswordField(
              label: 'Xác nhận mật khẩu',
              controller: confirmCtrl,
              obscure: confirmObscure,
              onToggle: toggleConfirm,
              validator: (v) =>
                  v != newPassCtrl.text ? 'Mật khẩu không khớp' : null,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onSubmit,
                child: const Text(
                  'Cập nhật mật khẩu',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
