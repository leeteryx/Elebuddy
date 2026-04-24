import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.4:8000/api";

  // Header standar agar Laravel mengenali request sebagai JSON
  static Map<String, String> _getHeaders([String? token]) {
    Map<String, String> headers = {'Accept': 'application/json'};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // --- 1. FUNGSI REGISTER ---
  static Future<http.Response> register({
    required String parentName,
    required String email,
    required String password,
    required String childName,
    required String childAge,
  }) async {
    final url = Uri.parse("$baseUrl/register");
    return await http.post(
      url,
      headers: _getHeaders(),
      body: {
        'name': parentName,
        'email': email,
        'password': password,
        'child_name': childName,
        'child_age': childAge,
      },
    );
  }

  // --- 2. FUNGSI LOGIN ---
  static Future<http.Response> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    return await http.post(
      url,
      headers: _getHeaders(),
      body: {'email': email, 'password': password},
    );
  }

  // --- 3. FUNGSI UPDATE STATUS SKRINING ---
  static Future<http.Response> updateScreeningStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("$baseUrl/update-screening");
    return await http.post(
      url,
      headers: _getHeaders(token), // Mengirimkan Token Sanctum
    );
  }
}
