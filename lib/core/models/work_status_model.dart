// lib/core/models/work_status_model.dart
class WorkStatus {
  final int id;
  final String name;
  final int count;
  final String color; // Hex string e.g. "#f39c12"

  WorkStatus({
    required this.id,
    required this.name,
    required this.count,
    required this.color,
  });

  factory WorkStatus.fromJson(Map<String, dynamic> json) {
    return WorkStatus(
      id: json['id'],
      name: json['name'],
      count: json['count'],
      color: json['color'] ?? '#0073b7',
    );
  }
}
