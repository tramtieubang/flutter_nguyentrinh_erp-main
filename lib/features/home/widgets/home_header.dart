import 'package:flutter/material.dart';

/// =======================================================
/// 👤 HOME HEADER
/// - Hiển thị avatar + tên + subtitle
/// - Không xử lý logic user (để HomeScreen lo)
/// =======================================================
class HomeHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final String avatar;

  const HomeHeader({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// ================= AVATAR =================
        CircleAvatar(
          radius: 24,
          key: ValueKey(avatar), // 🔥 ép rebuild khi avatar đổi
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
              /// ===== NAME =====
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              /// ===== SUBTITLE =====
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
