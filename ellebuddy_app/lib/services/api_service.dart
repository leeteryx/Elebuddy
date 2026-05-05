import 'dart:convert'; // Tambahkan ini untuk membaca JSON (jsonDecode)
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Ingat: Gunakan 127.0.0.1 untuk Chrome, atau 10.0.2.2 untuk Emulator Android
  static const String baseUrl = "http://127.0.0.1:8000/api";

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

  // --- 4. FUNGSI SIMPAN SKOR GAME ---
  static Future<http.Response> saveGameScore(String gameName, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Ambil ID user dari SharedPreferences (disimpan saat login)
    final userId = prefs.getInt('user_id_key');

    // Mencegah pengiriman jika tidak ada user yang login
    if (userId == null) {
      throw Exception("User ID tidak ditemukan. Pastikan sudah login.");
    }

    final url = Uri.parse("$baseUrl/save-score");
    return await http.post(
      url,
      headers: _getHeaders(token),
      body: {
        'user_id': userId.toString(),
        'game_name': gameName, // <-- Data nama game dikirim
        'score': score.toString(),
      },
    );
  }

  // --- 5. FUNGSI MENGAMBIL HASIL GAME ---
  static Future<Map<String, int>> getGameResults() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('user_id_key');

    if (userId == null) return {}; // Kembalikan kosong jika belum login

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

        // Memasukkan data ke dalam format Map { "Nama Game": Skor }
        for (var item in data['data']) {
          resultMap[item['game_name']] = item['score'];
        }
        return resultMap;
      }
    } catch (e) {
      print("Error fetching game results: $e");
    }
    return {};
  }
}
