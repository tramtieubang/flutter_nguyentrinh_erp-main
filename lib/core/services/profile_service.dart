import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../config/api_config.dart';
import '../models/profile_model.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';

import '../services/auth_service.dart';
//import '../models/user_model.dart';

class ProfileService {
  ProfileService._();

  /// ==================================
  /// 👤 LẤY THÔNG TIN PROFILE
  /// GET /user-profile/profile
  /// ==================================
  static Future<ProfileModel?> getProfile() async {
    try {
      final response = await ApiClient.get('/user-profile/profile');

      if (response.statusCode != 200) return null;

      final jsonData = jsonDecode(response.body);

      if (jsonData['success'] == true && jsonData['data'] != null) {
        return ProfileModel.fromJson(jsonData['data']);
      }

      return null;
    } catch (e) {
      debugPrint('getProfile exception: $e');
      return null;
    }
  }

  /// ==================================
  /// 🔄 UPDATE PROFILE + AVATAR
  /// POST /user-profile/update-profile
  /// multipart/form-data
  /// ==================================
  static Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? avatar, // Ảnh đại diện (nullable)
  }) async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null || token.isEmpty) return false;

      /// 🔗 URL
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/user-profile/update-profile',
      );

      /// 📦 MULTIPART REQUEST
      final request = http.MultipartRequest('POST', uri);

      /// 🔐 HEADER
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      /// 📝 TEXT FIELDS
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone'] = phone;

      /// 🖼️ FILE AVATAR
      if (avatar != null && await avatar.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar', // ⚠️ phải trùng backend
            avatar.path,
          ),
        );
      }

      /// 🚀 SEND REQUEST
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        debugPrint('Update profile HTTP error: ${response.statusCode}');
        return false;
      }

      final jsonData = jsonDecode(response.body);

      if (jsonData['success'] != true || jsonData['data'] == null) {
        debugPrint('Update profile failed: ${jsonData['message']}');
        return false;
      }

      /// 🔥🔥🔥 BACKEND PHẢI TRẢ USER MỚI
      //final updatedUser = UserModel.fromJson(jsonData['data']);

      /// 🔥🔥🔥 CẬP NHẬT SESSION TOÀN APP
      //await AuthService.updateCurrentUser(updatedUser);

      await AuthService.reloadFromApi();

      return true;
    } catch (e) {
      debugPrint('updateProfile exception: $e');
      return false;
    }
  }
}
