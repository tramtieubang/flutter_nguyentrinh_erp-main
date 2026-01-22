class WorkAssignmentModel {
  final int id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;

  final int staffCode;
  final String staffName;

  final int statusId;
  final String statusName;
  final String statusColor;

  final int registeredId;
  final String registeredTitle;
  final String registeredDescription;
  final String registeredStartDate;
  final String registeredEndDate;
  final String registeredStatusName;
  final String registeredStatusColor;

  WorkAssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,

    required this.staffCode,
    required this.staffName,

    required this.statusId,
    required this.statusName,
    required this.statusColor,

    required this.registeredId,
    required this.registeredTitle,
    required this.registeredDescription,
    required this.registeredStartDate,
    required this.registeredEndDate,
    required this.registeredStatusName,
    required this.registeredStatusColor,
  });

  factory WorkAssignmentModel.fromJson(Map<String, dynamic> json) {
    final registered = json['registered'] ?? {};

    return WorkAssignmentModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',

      staffCode: json['staffCode'] ?? 0,
      staffName: json['staffName'] ?? '',

      statusId: json['statusId'] ?? 0,
      statusName: json['statusName'] ?? '',
      statusColor: json['statusColor'] ?? '',

      registeredId: registered['id'] ?? 0,
      registeredTitle: registered['title'] ?? '',
      registeredDescription: registered['description'] ?? '',
      registeredStartDate: registered['startDate'] ?? '',
      registeredEndDate: registered['endDate'] ?? '',
      registeredStatusName: registered['statusName'] ?? '',
      registeredStatusColor: registered['statusColor'] ?? '',
    );
  }

  /// Dùng khi lưu local / debug
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,

      'staffCode': staffCode,
      'staffName': staffName,

      'statusId': statusId,
      'statusName': statusName,
      'statusColor': statusColor,

      'registered': {
        'id': registeredId,
        'title': registeredTitle,
        'description': registeredDescription,
        'startDate': registeredStartDate,
        'endDate': registeredEndDate,
        'statusName': registeredStatusName,
        'statusColor': registeredStatusColor,
      },
    };
  }
}
