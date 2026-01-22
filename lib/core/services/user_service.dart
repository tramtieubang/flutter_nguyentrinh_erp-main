import 'dart:convert';

import '../models/user_model.dart';
import '../network/api_client.dart';
import '../../config/api_config.dart';

class UserService {
  /// Lấy thông tin user đang đăng nhập
  static Future<UserModel?> getProfile() async {
    try {
      final response = await ApiClient.get(ApiConfig.profile);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Trường hợp API bọc success
        if (data is Map && data['success'] == true) {
          return UserModel.fromJson(data['user']);
        }

        // Trường hợp API trả thẳng user
        return UserModel.fromJson(data);
      }

      // Token sai / hết hạn
      if (response.statusCode == 401) {
        return null;
      }
    } catch (e) {
      // log lỗi nếu cần
    }

    return null;
  }
}
