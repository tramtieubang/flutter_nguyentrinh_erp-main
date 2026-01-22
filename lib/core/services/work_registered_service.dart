import 'dart:convert';

import '../models/work_registered_model.dart';
import '../models/work_status_model.dart';
import '../network/api_client.dart';

/// Service xử lý Công việc đăng ký
/// - Dùng chung cho Home / Work / Notification
class WorkRegisteredService {
  /// 📋 Danh sách công việc đăng ký
  /// Có thể lọc theo status
  static Future<List<WorkRegisteredModel>> getWorks({int? status}) async {
    String url = '/work-registered/works';

    if (status != null) {
      url += '?status=$status';
    }

    final response = await ApiClient.get(url);

    if (response.statusCode != 200) return [];

    final jsonData = jsonDecode(response.body);
    if (jsonData['success'] != true) return [];

    final List list = jsonData['data'] as List;

    return list
        .map((e) => WorkRegisteredModel.fromJson(e))
        .toList();
  }

  /// 🔍 Chi tiết công việc đăng ký
  static Future<WorkRegisteredModel> getWorkDetail(int workId) async {
    final response = await ApiClient.get(
      '/work-registered/work-detail?workId=$workId',
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể tải chi tiết công việc');
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['success'] != true) {
      throw Exception(jsonData['message'] ?? 'Dữ liệu không hợp lệ');
    }

    return WorkRegisteredModel.fromJson(jsonData['data']);
  }

  /// 📊 Đếm số công việc theo trạng thái
  static Future<List<WorkStatus>> getStatusCounts() async {
    final response =
        await ApiClient.get('/work-registered/status-count');

    if (response.statusCode != 200) {
      throw Exception('Không thể load trạng thái công việc');
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['success'] != true) {
      throw Exception(jsonData['message'] ?? 'Dữ liệu không hợp lệ');
    }

    final List list = jsonData['data'] as List;

    return list.map((e) => WorkStatus.fromJson(e)).toList();
  }

  /// ➕ Đăng ký công việc mới
  static Future<bool> submit({
    required String title,
    String? description,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    final response = await ApiClient.post(
      '/work-registered/create',
      body: {
        'title': title,
        'description': description,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
      },
    );

    if (response.statusCode != 200) return false;

    final jsonData = jsonDecode(response.body);
    return jsonData['success'] == true;
  }
}
