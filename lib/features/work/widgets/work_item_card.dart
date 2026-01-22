import 'package:flutter/material.dart';
import '../../../core/models/work_assignment_model.dart';
import '../../../core/utils/color_helper.dart';
import '../work_detail_screen.dart';
import 'work_info.dart';

class WorkItemCard extends StatelessWidget {
  final WorkAssignmentModel item;

  const WorkItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    /// 🎨 MÀU ICON THEO STATUS TỪ API
    final Color statusColor =
        ColorHelper.hexToColor(item.statusColor);

    /// 🔹 ICON THEO TRẠNG THÁI
    final IconData iconData =
        _getIconByStatusName(item.statusName);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkDetailScreen(
              title: item.title,
              startDate: item.startDate,
              endDate: item.endDate,
              description: item.description,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade900.withAlpha(40),
              Colors.blueGrey.shade700.withAlpha(20),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withAlpha(38)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 🔥 ICON – CHỈ ĐỔI MÀU THEO STATUS
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(30),
              ),
              child: Icon(
                iconData,
                color: statusColor, // ✅ CHỈ DÒNG NÀY ĐỔI
                size: 22,
              ),
            ),

            const SizedBox(width: 16),

            /// 📄 THÔNG TIN CÔNG VIỆC
            Expanded(child: WorkInfo(item: item)),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 MAP ICON THEO TRẠNG THÁI
  IconData _getIconByStatusName(String name) {
    switch (name) {
      case 'Hoàn thành':
        return Icons.check_circle_outline;
      case 'Đang thực hiện':
        return Icons.autorenew;
      case 'Trễ hạn':
        return Icons.warning_amber_rounded;
      case 'Tạm dừng':
        return Icons.pause_circle_outline;
      case 'Bị hủy':
        return Icons.cancel_outlined;
      default:
        return Icons.work_outline;
    }
  }
}
