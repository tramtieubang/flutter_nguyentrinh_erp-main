import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String avatar;
  final String subtitle;

  const HomeHeader({
    super.key,
    required this.name,
    required this.avatar,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// ================= AVATAR =================
        CircleAvatar(
          radius: 24,
          backgroundImage:
              avatar.isNotEmpty ? NetworkImage(avatar) : null,
          child: avatar.isEmpty
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),

        const SizedBox(width: 12),

        /// ================= USER INFO =================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
