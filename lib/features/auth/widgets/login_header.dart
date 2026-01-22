import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final AnimationController mainCtrl;

  const LoginHeader({super.key, required this.mainCtrl});

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: mainCtrl, curve: Curves.easeOut);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: mainCtrl, curve: Curves.easeOutCubic));

    return Column(
      children: [
        const SizedBox(height: 60),
        Image.asset('assets/icons/logo.png', height: 70),
        const SizedBox(height: 12),
        FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: const Text(
              'ĐĂNG NHẬP HỆ THỐNG',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
