import 'dart:convert'; // Tambahkan ini
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/constants.dart';
import '../../widgets/custom_input.dart';
import '../../services/api_service.dart'; // Import ApiService kita
import '../screener/intro_screen.dart';
import '../game/game_menu_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> login() async {
    // Validasi input kosong
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showError("Email dan Password tidak boleh kosong");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Panggil ApiService untuk Login ke Laravel
      final response = await ApiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();

        // 2. Simpan Token dari Laravel (PENTING untuk akses fitur lain)
        await prefs.setString('token', data['token']);
        await prefs.setBool('isLoggedIn', true);

        // 3. Ambil status skrining langsung dari database Laravel
        // Laravel mengirimkan 0 atau 1, kita ubah ke bool
        bool hasCompletedScreening =
            data['user']['has_completed_screening'] == 1;
        await prefs.setBool('hasCompletedScreening', hasCompletedScreening);

        // Simpan nama anak juga biar bisa dipanggil di Game Menu nanti
        await prefs.setString(
          'child_name',
          data['user']['child_name'] ?? "Si Kecil",
        );

        if (!mounted) return;

        // 4. Navigasi berdasarkan status skrining di DB
        if (hasCompletedScreening) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const GameMenuScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const IntroScreen()),
            (route) => false,
          );
        }
      } else {
        // Gagal login (email/pass salah)
        _showError(data['message'] ?? "Email atau Password salah");
      }
    } catch (e) {
      _showError(
        "Gagal terhubung ke server. Pastikan Laravel jalan & IP benar.",
      );
      print("Login Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Image.asset(
                'images/elephant.png', // Pastikan file ini ada di folder images
                height: 150,
              ),
              const Text("Masuk Orang Tua", style: AppTextStyle.brandTitle),
              const SizedBox(height: 30),
              CustomInput(
                controller: emailController,
                hint: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              CustomInput(
                controller: passwordController,
                hint: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Masuk",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Daftar di sini",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
