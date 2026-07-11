import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      "https://intelligent-imagination-production-3690.up.railway.app/api";

  static Map<String, String> _getHeaders([String? token]) {
    Map<String, String> headers = {'Accept': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id_key');
  }

  // ── 1. REGISTER ─────────────────────────────────────────────────────────
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

  // ── 2. LOGIN ─────────────────────────────────────────────────────────────
  static Future<http.Response> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    return await http.post(
      url,
      headers: _getHeaders(),
      body: {'email': email, 'password': password},
    );
  }

  // ── 3. UPDATE STATUS SKRINING ────────────────────────────────────────────
  static Future<http.Response> updateScreeningStatus() async {
    final token = await _getToken();
    final url = Uri.parse("$baseUrl/update-screening");
    return await http.post(url, headers: _getHeaders(token));
  }

  // ── 4. SIMPAN SKOR GAME ──────────────────────────────────────────────────
  static Future<http.Response> saveGameScore(String gameName, int score) async {
    final token = await _getToken();
    final userId = await _getUserId();

    if (userId == null) {
      throw Exception("User ID tidak ditemukan. Pastikan sudah login.");
    }

    final url = Uri.parse("$baseUrl/save-score");
    return await http.post(
      url,
      headers: _getHeaders(token),
      body: {
        'user_id': userId.toString(),
        'game_name': gameName,
        'score': score.toString(),
      },
    );
  }

  // ── 5. AMBIL HASIL GAME ──────────────────────────────────────────────────
  static Future<Map<String, int>> getGameResults() async {
    final token = await _getToken();
    final userId = await _getUserId();

    if (userId == null) return {};

    final url = Uri.parse("$baseUrl/get-game-results");

    try {
      final response = await http.post(
        url,
        headers: _getHeaders(token),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Map<String, int> resultMap = {};
        for (var item in data['data']) {
          resultMap[item['game_name']] = item['score'];
        }
        return resultMap;
      }
    } catch (e) {
      print("Error getGameResults: $e");
    }
    return {};
  }

  // ── 6. AMBIL PROFIL ANAK ─────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getProfilAnak() async {
    final token = await _getToken();

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/profil-anak"),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error getProfilAnak: $e");
    }
    return null;
  }

  // ── 7. UPDATE PROFIL ANAK ────────────────────────────────────────────────
  static Future<bool> updateProfilAnak({
    required String childName,
    required int childAge,
    required String childGender, // 'L' atau 'P'
    required String childNotes,
  }) async {
    final token = await _getToken();

    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/profil-anak"),
        headers: _getHeaders(token),
        body: {
          'child_name': childName,
          'child_age': childAge.toString(),
          'child_gender': childGender,
          'child_notes': childNotes,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
    } catch (e) {
      print("Error updateProfilAnak: $e");
    }
    return false;
  }
}
