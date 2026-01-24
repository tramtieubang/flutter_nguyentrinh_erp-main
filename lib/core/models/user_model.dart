import 'profile_model.dart';

class UserModel {
  final int id;
  final String username;
  final String? email;
  final ProfileModel? profile;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    this.profile,
  });

  /// ===============================
  /// FACTORY
  /// ===============================
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      username: json['username'] ?? '',
      email: json['email'],
      profile: json['staff'] != null
          ? ProfileModel.fromJson(json['staff'])
          : null,
    );
  }

  /// ===============================
  /// GETTERS TIỆN DÙNG CHO UI
  /// ===============================

  /// 👤 Tên hiển thị (ưu tiên profile.name)
  String get displayName {
    final name = profile?.name;
    if (name != null && name.isNotEmpty) return name;
    return username;
  }

  /// 📞 Dố DT
  String get displayPhone {
    final phone = profile?.phone;
    if (phone != null && phone.isNotEmpty) return phone;
    return 'Chưa cập nhật';
  }

  /// 🖼 Avatar (lấy từ staff/profile)
  String get avatar {
    return profile?.avatar ?? '';
  }
  

  /// 📧 Email ưu tiên profile
  String? get displayEmail {
    return profile?.email ?? email;
  }
  

  /// ===============================
  /// TO JSON
  /// ===============================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'staff': profile?.toJson(),
    };
  }
}
