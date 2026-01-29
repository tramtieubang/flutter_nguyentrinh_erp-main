import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'access_token';

  /// 🔐 LƯU TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// 🔓 LẤY TOKEN
  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  /// ❌ XOÁ TOKEN
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
