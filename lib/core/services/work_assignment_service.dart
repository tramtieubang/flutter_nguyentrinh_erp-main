import 'dart:convert';
import '../models/work_assignment_model.dart';
import '../network/api_client.dart';
import '../models/work_status_model.dart';

class WorkAssignmentService {
  
  static Future<List<WorkAssignmentModel>> getWorks({int? status}) async {
    String url = '/work-assignment/works';

    // 🔥 thêm query string nếu có status
    if (status != null) {
      url += '?status=$status';
    }

    final response = await ApiClient.get(url);

    if (response.statusCode != 200) return [];

    final jsonData = jsonDecode(response.body);
    if (jsonData['success'] != true) return [];

    final List list = jsonData['data'];

    return list
        .map((e) => WorkAssignmentModel.fromJson(e))
        .toList();
  }

  /// Lấy chi tiết công việc theo ID
  static Future<WorkAssignmentModel> getWorkDetail(int workId) async {
    final response =
        await ApiClient.get('/work-assignment/work-detail?workId=$workId');

    if (response.statusCode != 200) {
      throw Exception('Không thể tải chi tiết công việc');
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['success'] != true) {
      throw Exception(jsonData['message'] ?? 'Dữ liệu không hợp lệ');
    }

    return WorkAssignmentModel.fromJson(jsonData['data']);
  }

  /// Lấy số lượng công việc theo trạng thái
  static Future<List<WorkStatus>> getStatusCounts() async {
    final response = await ApiClient.get('/work-assignment/status-count');

    if (response.statusCode != 200) {
      throw Exception('Không thể load dữ liệu trạng thái công việc');
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['success'] != true) {
      throw Exception(jsonData['message'] ?? 'Dữ liệu không hợp lệ');
    }

    final List list = jsonData['data'] as List;

    return list.map((e) => WorkStatus.fromJson(e)).toList();
  }

  
}
