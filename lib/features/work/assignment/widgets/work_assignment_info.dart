import 'package:flutter/material.dart';
import '../../../../core/models/work_assignment_model.dart';

class WorkAssignmentInfo extends StatelessWidget {
  final WorkAssignmentModel item;

  const WorkAssignmentInfo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${item.startDate} • ${item.endDate}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
