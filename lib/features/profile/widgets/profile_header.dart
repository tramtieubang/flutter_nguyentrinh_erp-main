import 'package:flutter/material.dart';
import '../../../core/models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel? profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile?.avatar;

    /// 🔑 thêm query để phá cache ảnh
    final avatarWithCacheBust = (avatarUrl != null && avatarUrl.isNotEmpty)
        ? '$avatarUrl?v=${DateTime.now().millisecondsSinceEpoch}'
        : null;

    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF203A43), Color(0xFF2C5364)],
            ),
            image: avatarWithCacheBust != null
                ? DecorationImage(
                    image: NetworkImage(avatarWithCacheBust),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: avatarWithCacheBust == null
              ? const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          profile?.name ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
