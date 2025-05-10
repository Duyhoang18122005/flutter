import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const Duration timeout = Duration(seconds: 10);
  static final storage = FlutterSecureStorage();


  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };


  static Future<Map<String, String>> get _headersWithToken async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<String?> login(String username, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'jwt', value: data['token']);
        return null;
      } else {
        final error = jsonDecode(response.body);
        return error['message'] ?? 'Sai tài khoản hoặc mật khẩu';
      }
    } catch (e) {
      if (e is http.ClientException) {
        return 'Không thể kết nối đến máy chủ';
      }
      return 'Đã xảy ra lỗi: ${e.toString()}';
    }
  }

  static Future<String?> register(String username, String password, String email, String fullName) async {
    try {
      final url = Uri.parse('$baseUrl/auth/register');
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
          'fullName': fullName,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      } else {
        final error = jsonDecode(response.body);
        return error['message'] ?? 'Đăng ký thất bại';
      }
    } catch (e) {
      if (e is http.ClientException) {
        return 'Không thể kết nối đến máy chủ';
      }
      return 'Đã xảy ra lỗi: ${e.toString()}';
    }
  }

  static Future<void> logout() async {
    try {
      await storage.delete(key: 'jwt');
    } catch (e) {
      print('Lỗi khi đăng xuất: ${e.toString()}');
    }
  }

  static Future<String?> getToken() async {
    try {
      return await storage.read(key: 'jwt');
    } catch (e) {
      print('Lỗi khi đọc token: ${e.toString()}');
      return null;
    }
  }

  // Thêm method kiểm tra token còn hạn không
  static Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final url = Uri.parse('$baseUrl/validate');
      final response = await http.get(
        url,
        headers: await _headersWithToken,
      ).timeout(timeout);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> registerPlayer(Map<String, dynamic> data) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$baseUrl/game-players');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      ).timeout(timeout);

      if (response.statusCode == 201) {
        return null;
      } else {
        final error = jsonDecode(response.body);
        return error['message'] ?? 'Đăng ký player thất bại';
      }
    } catch (e) {
      return 'Đã xảy ra lỗi: ${e.toString()}';
    }
  }

  static Future<List<dynamic>> fetchAllPlayers() async {
    try {
      final url = Uri.parse('$baseUrl/game-players/available');
      final response = await http.get(url).timeout(timeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> fetchPlayerById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/game-players/$id');
      final response = await http.get(url).timeout(timeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}