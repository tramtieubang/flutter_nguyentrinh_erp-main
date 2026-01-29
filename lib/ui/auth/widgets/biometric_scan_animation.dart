import 'package:flutter/material.dart';

class BiometricScanAnimation extends StatefulWidget {
  final bool scanning;
  final bool success;

  const BiometricScanAnimation({
    super.key,
    required this.scanning,
    required this.success,
  });

  @override
  State<BiometricScanAnimation> createState() =>
      _BiometricScanAnimationState();
}

class _BiometricScanAnimationState extends State<BiometricScanAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant BiometricScanAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Khi quét xong → dừng animation
    if (widget.success) {
      _ctrl.stop();
    } else if (widget.scanning) {
      _ctrl.repeat();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        final scale = 1 + (_ctrl.value * 0.15);
        final opacity = 1 - _ctrl.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            /// Sóng lan
            if (!widget.success)
              Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue.withAlpha((0.5 * 255).round()),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

            /// Icon vân tay
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                widget.success
                    ? Icons.check_circle
                    : Icons.fingerprint,
                size: 80,
                color: widget.success
                    ? Colors.green
                    : Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }
}
