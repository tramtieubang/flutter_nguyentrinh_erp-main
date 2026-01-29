import 'dart:math';
import 'package:flutter/material.dart';

class BiometricBottomSheet extends StatefulWidget {
  /// Callback trả về TRUE nếu xác thực thành công
  final Future<bool> Function() onAuthenticate;

  const BiometricBottomSheet({
    super.key,
    required this.onAuthenticate,
  });

  @override
  State<BiometricBottomSheet> createState() => _BiometricBottomSheetState();
}

class _BiometricBottomSheetState extends State<BiometricBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  bool _processing = false;
  String _message = 'Chạm vân tay để đăng nhập';

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (_processing) return;

    setState(() {
      _processing = true;
      _message = 'Đang xác thực...';
    });

    final success = await widget.onAuthenticate();
    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _processing = false;
        _message = 'Xác thực thất bại, thử lại';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              /// Fingerprint animation
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, _) {
                  final scale =
                      1 + sin(_pulseCtrl.value * 2 * pi) * 0.08;
                  return Transform.scale(
                    scale: scale,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _handleAuth,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withAlpha(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withAlpha(90),
                              blurRadius: 30,
                              spreadRadius: _processing ? 10 : 4,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.fingerprint,
                          size: 64,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Huỷ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
