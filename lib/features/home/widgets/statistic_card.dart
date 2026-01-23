import 'package:flutter/material.dart';
import '../../../core/models/work_status_model.dart';
import '../../../core/utils/color_helper.dart';

class StatisticCard extends StatelessWidget {
  final List<WorkStatus> statuses;

  /// ✅ callback chuẩn – named parameters
  final void Function({
    int? statusId,
    required int tabBottomIndex,
    required int tabTopIndex,
  }) onTapStatus;

  const StatisticCard({
    super.key,
    required this.statuses,
    required this.onTapStatus,
  });

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 104;
    const double cardHeight = 180;

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];

          final Color statusColor =
              ColorHelper.hexToColor(status.color);

          final IconData iconData =
              _getIconByStatusName(status.name);

          return InkWell(
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white24,

            /// ✅ GỌI CALLBACK ĐÚNG KIỂU
            onTap: () => onTapStatus(
              statusId: status.id,
              tabBottomIndex: 2, // 👉 Công việc
              tabTopIndex: 1,    // 👉 Tab trạng thái
            ),

            child: Container(
              width: cardWidth,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    statusColor.withAlpha((0.95 * 255).round()),
                    statusColor.withAlpha((0.75 * 255).round()),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withAlpha((0.35 * 255).round()),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha((0.25 * 255).round()),
                      border: Border.all(
                        color: Colors.white.withAlpha((0.6 * 255).round()),
                      ),
                    ),
                    child: Icon(
                      iconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    status.count.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconByStatusName(String name) {
    switch (name) {
      case 'Hoàn thành':
        return Icons.check_circle_outline;
      case 'Chưa hoàn thành':
        return Icons.assignment_late_outlined;
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
