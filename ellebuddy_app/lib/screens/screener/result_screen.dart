import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/result_data.dart';
import '../dashboard/login_screen.dart';
import '../game/game_menu_screen.dart';
import '../../widgets/constants.dart';

class ResultScreen extends StatelessWidget {
  final String
  status; // Ini akan menerima 'excellent', 'warning', atau 'danger'

  const ResultScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // MENGAMBIL DATA DARI resultOptions BERDASARKAN STATUS
    final result = resultOptions[status] ?? resultOptions['excellent']!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Tombol Back
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF23A1B1),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const Spacer(),

              // 1. Gambar Gajah (imagePath dari data)
              Image.asset(
                result.imagePath,
                height: 220,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, size: 100),
              ),

              const SizedBox(height: 30),

              // 2. Judul Hasil (title dari data - Warna Ungu sesuai desain)
              Text(
                result.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A5AE0), // Warna Ungu EleBuddy
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 40),

              // 3. Deskripsi Stimulasi (description dari data - Warna Oranye)
              Text(
                result.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFF9A825),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 50),

              // 4. TOMBOL CONTINUE DENGAN LOGIKA VALIDASI
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

                    // Tandai bahwa skrining sudah diselesaikan
                    await prefs.setBool('hasCompletedScreening', true);

                    if (!context.mounted) return;

                    if (isLoggedIn) {
                      // Jika sudah login (User Baru yang Daftar-Login di awal)
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameMenuScreen(),
                        ),
                        (route) => false,
                      );
                    } else {
                      // Jika belum login (User Guest)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Footer Logo
              Column(
                children: [
                  const Text(
                    "elebuddy",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Image.asset('images/elephant.png', height: 40),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
