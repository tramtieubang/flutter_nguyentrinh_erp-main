import 'package:flutter/material.dart';

class WorkIcon extends StatelessWidget {
  const WorkIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade400.withAlpha(200),
            Colors.green.shade200.withAlpha(200),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.work_outline,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
