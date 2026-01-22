import 'package:flutter/material.dart';
import '../../../config/routes.dart';
import '../change_password/change_password_screen.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../../../core/services/auth_service.dart';

class ProfileActionCard extends StatelessWidget {
  final VoidCallback onProfileUpdated; // ✅ THÊM

  const ProfileActionCard({
    super.key,
    required this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _actionItem(
            icon: Icons.lock_outline,
            title: 'Đổi mật khẩu',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          /// 🔥 UPDATE PROFILE
          _actionItem(
            icon: Icons.person_outline,
            title: 'Cập nhật thông tin',
            onTap: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => const UpdateProfileScreen(),
                ),
              );

              /// ✅ NẾU UPDATE THÀNH CÔNG → RELOAD PROFILE
              if (result == true) {
                onProfileUpdated();
              }
            },
          ),

          const Divider(height: 1),

          _actionItem(
            icon: Icons.logout,
            title: 'Đăng xuất',
            danger: true,
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String title,
    bool danger = false,
    required VoidCallback onTap,
  }) {
    final color = danger ? const Color(0xFFD32F2F) : const Color(0xFF203A43);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  /// 🔐 Dialog xác nhận đăng xuất
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Đăng xuất'),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await AuthService.logout();

                if (!context.mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.login,
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
