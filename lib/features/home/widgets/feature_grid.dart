import 'package:flutter/material.dart';
import 'feature_item.dart';
import '../../../config/routes.dart';

class FeatureGrid extends StatelessWidget {
  /// Callback đổi tab từ Home → MainScreen
  final void Function({
    int? statusId,
    required int tabBottomIndex,
    int tabTopIndex,
  })? onChangeTab;

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
        /// ===== CÔNG VIỆC =====
        FeatureItem(
          icon: Icons.work_rounded,
          label: 'Công việc',
          iconColor: const Color(0xFF43A047),
          onTap: () {
            onChangeTab?.call(
              tabBottomIndex: 2, // tab Công việc
              tabTopIndex: 1,    // tab "Đã duyệt" (ví dụ)
            );
          },
        ),

        /// ===== ĐĂNG KÝ =====
        FeatureItem(
          icon: Icons.app_registration_rounded,
          label: 'Đăng ký',
          iconColor: const Color(0xFFFFA726),
          onTap: () {
            Navigator.pushNamed(context, Routes.workRegister);
          },
        ),

        FeatureItem(
          icon: Icons.assignment_rounded,
          label: 'Báo cáo',
          iconColor: const Color(0xFF26A69A),
        ),

        FeatureItem(
          icon: Icons.query_stats_rounded,
          label: 'Thống kê',
          iconColor: const Color(0xFF42A5F5),
        ),
      ],
    );
  }
}
