import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String label;
  final Color iconColor;
  final VoidCallback? onTap; // 👈 THÊM DÒNG NÀY

  const FeatureItem({
    super.key,
    this.icon,
    this.customIcon,
    required this.label,
    required this.iconColor,
    this.onTap, // 👈 THÊM DÒNG NÀY
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap, // 👈 DÙNG CALLBACK
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.05 * 255).round()),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customIcon ??
                Container(
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha((0.2 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    icon,
                    size: 28,
                    color: iconColor,
                  ),
                ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withAlpha((0.9 * 255).round()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
