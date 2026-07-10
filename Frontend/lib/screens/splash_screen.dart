import 'dart:async';
import 'package:flutter/material.dart';
import 'screener/intro_screen.dart';
import '../widgets/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Durasi 3 detik sebelum pindah ke HomeScreen
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Gunakan warna latar dari constants
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nama Aplikasi
            const Text(
              "elebuddy",
              style: AppTextStyle.brandTitle, // Gunakan gaya teks brand kita
            ),

            const SizedBox(height: 30),

            // Logo Gajah
            Image.asset(
              "images/elephant.png",
              height: 200,
              // Jika gambar tidak ketemu, tampilkan icon cadangan
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.face_retouching_natural,
                size: 100,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 40),

            // Indikator Loading yang Serasi
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),

            const SizedBox(height: 20),

            const Text(
              "Menyiapkan petualanganmu...",
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
