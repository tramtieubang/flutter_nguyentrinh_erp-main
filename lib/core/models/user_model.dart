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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'staff': profile?.toJson(),
    };
  }
}
