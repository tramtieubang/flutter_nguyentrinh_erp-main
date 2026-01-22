import 'package:flutter/material.dart';
import '../../../core/models/profile_model.dart';
import 'info_row.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileModel? profile;

  const ProfileInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 18,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          InfoRow(
            icon: Icons.account_tree_outlined,
            label: 'Phòng ban',
            value: profile?.department ?? '',
          ),
           const Divider(),
          InfoRow(
            icon: Icons.work_outline,
            label: 'Chức vụ',
            value: profile?.position.toString() ?? '',
          ),
           const Divider(),
          InfoRow(
            icon: Icons.badge_outlined,
            label: 'Mã nhân viên',
            value: profile?.staffCode.toString() ?? '',
          ), 
          const Divider(),
          InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: profile?.email ?? '',
          ),
          const Divider(),
          InfoRow(
            icon: Icons.phone_outlined,
            label: 'Điện thoại',
            value: profile?.phone ?? '',
          ),
        ],
      ),
    );
  }
}
