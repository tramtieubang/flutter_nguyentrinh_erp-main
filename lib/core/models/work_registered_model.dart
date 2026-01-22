class WorkRegisteredModel {
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

  WorkRegisteredModel({
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
  });

  factory WorkRegisteredModel.fromJson(Map<String, dynamic> json) {
    final staff = json['staff'] ?? {};
    final status = json['status'] ?? {};

    return WorkRegisteredModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',

      staffCode: staff['staffCode'] ?? 0,
      staffName: staff['staffName'] ?? '',

      statusId: status['id'] ?? 0,
      statusName: status['name'] ?? '',
      statusColor: status['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'staff': {
        'staffCode': staffCode,
        'staffName': staffName,
      },
      'status': {
        'id': statusId,
        'name': statusName,
        'color': statusColor,
      },
    };
  }
}
