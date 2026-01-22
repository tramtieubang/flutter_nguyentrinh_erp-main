class ProfileModel {
  final int id;
  final String username;
  final String name;
  final String email;
  final String phone;
  final int staffCode;
  final String department;
  final String position;
  final String businessField;
  final String? avatar; // ✅ avatar có thể null

  ProfileModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.phone,
    required this.staffCode,
    required this.department,
    required this.position,
    required this.businessField,
    this.avatar,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: (json['id'] ?? json['staff_id'] ?? 0) as int,
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      staffCode: (json['staff_id'] ?? json['id'] ?? 0) as int,
      department: json['department'] as String? ?? '',
      position: json['position'] as String? ?? '',
      businessField: json['business_field'] as String? ?? '',
      avatar: json['avatar'] as String?, // ✅ URL đầy đủ từ backend
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'staff_id': staffCode,
      'department': department,
      'position': position,
      'business_field': businessField,
      'avatar': avatar,
    };
  }
}
