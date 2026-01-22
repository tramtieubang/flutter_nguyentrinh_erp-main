import 'package:flutter/material.dart';
import 'feature_item.dart';
import 'notification_icon_badge.dart';
import '../../../core/services/notification_service.dart';
import '../../../config/routes.dart';

class FeatureGrid extends StatelessWidget {
  /// Callback đổi tab từ MainScreen
  final void Function(int index)? onChangeTab;

  const FeatureGrid({
    super.key,
    this.onChangeTab,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      children: [
        FeatureItem(
          icon: Icons.work_outline,
          label: 'Công việc',
          iconColor: Colors.green,
          onTap: () {
            onChangeTab?.call(2); // tab Công việc
          },
        ),
        FeatureItem(
          icon: Icons.app_registration,
          label: 'Đăng ký',
          iconColor: Colors.orange,
          onTap: () {
            Navigator.pushNamed(context, Routes.workRegister);
          },
        ),
        FeatureItem(
          icon: Icons.bar_chart_outlined,
          label: 'Báo cáo',
          iconColor: Colors.blue,
        ),

        /// 🔔 THÔNG BÁO – CLICK → CHUYỂN TAB THÔNG BÁO
        FutureBuilder<int>(
          future: NotificationService.countUnread(),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;

            return FeatureItem(
              customIcon: NotificationIconBadge(
                count: count,
                color: Colors.red,
              ),
              label: 'Thông báo',
              iconColor: Colors.red,
              onTap: () {
                onChangeTab?.call(1); // 👈 tab Thông báo
              },
            );
          },
        ),
      ],
    );
  }
}
