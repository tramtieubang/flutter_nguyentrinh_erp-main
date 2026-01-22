import 'package:flutter/material.dart';

class RegisterSubmitButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;

  const RegisterSubmitButton({
    super.key,
    required this.loading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Đăng ký công việc'),
      ),
    );
  }
}
