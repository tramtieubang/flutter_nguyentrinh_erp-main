import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/api_config.dart';
import '../storage/local_storage.dart';

class ApiClient {
  ApiClient._(); // ❌ không cho new

  // =================================================
  // 🔐 TOKEN IN-MEMORY (QUAN TRỌNG)
  // =================================================
  static String? _token;

  /// 🔥🔥🔥 GỌI KHI:
  /// - App start (main)
  /// - Login / biometric login
  static void setToken(String token) {
    _token = token;
  }

  /// 🔥 GỌI KHI FORCE LOGOUT
  static void clearToken() {
    _token = null;
  }

  // =================================================
  // 🔐 HEADER CHUNG CHO TẤT CẢ REQUEST
  // - Ưu tiên token in-memory
  // - Fallback LocalStorage (tương thích code cũ)
  // =================================================
  static Future<Map<String, String>> _headers({
    Map<String, String>? extra,
  }) async {
    String? token = _token;

    /// Fallback (lần đầu app mở)
    token ??= await LocalStorage.getToken();

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
      if (extra != null) ...extra,
    };
  }

  // =================================================
  // 🔹 BUILD URI (hỗ trợ query parameters)
  // =================================================
  static Uri _buildUri(
    String endpoint, {
    Map<String, String>? query,
  }) {
    final base = Uri.parse(ApiConfig.baseUrl + endpoint);

    if (query == null || query.isEmpty) return base;

    return base.replace(queryParameters: query);
  }

  // =================================================
  // 📌 GET REQUEST
  // =================================================
  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint, query: query);

    return http.get(
      uri,
      headers: await _headers(extra: headers),
    );
  }

  // =================================================
  // 📌 POST REQUEST
  // =================================================
  static Future<http.Response> post(
    String endpoint, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint, query: query);

    return http.post(
      uri,
      headers: await _headers(extra: headers),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // =================================================
  // 📌 PUT REQUEST
  // =================================================
  static Future<http.Response> put(
    String endpoint, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint, query: query);

    return http.put(
      uri,
      headers: await _headers(extra: headers),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  // =================================================
  // 📌 DELETE REQUEST
  // =================================================
  static Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint, query: query);

    return http.delete(
      uri,
      headers: await _headers(extra: headers),
    );
  }
}
