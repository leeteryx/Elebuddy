import 'package:flutter/material.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/constants.dart';
import '../../widgets/custom_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller Data Orang Tua
  final parentNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Controller Data Anak
  final childNameController = TextEditingController();
  final childAgeController = TextEditingController();

  bool _isLoading = false;

  Future<void> register() async {
    // 1. Validasi Input Dasar
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        childNameController.text.isEmpty) {
      _showMessage(
        "Mohon lengkapi email dan nama anak ya Bunda/Ayah",
        Colors.redAccent,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Kirim data ke Laravel melalui ApiService
      final response = await ApiService.register(
        parentName: parentNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        childName: childNameController.text.trim(),
        childAge: childAgeController.text.trim(),
      );

      // 3. Decode response dari Laravel
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        // Jika berhasil, kita simpan token dan data dasar ke lokal (opsional)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setBool('isRegistered', true);
        await prefs.setString('child_name', childNameController.text.trim());

        _showMessage(
          "Pendaftaran Berhasil! Halo ${childNameController.text}",
          AppColors.primary,
        );

        if (!mounted) return;
        Navigator.pop(context); // Kembali ke halaman Login
      } else {
        // Jika gagal (misal: email sudah terdaftar)
        _showMessage(data['message'] ?? "Pendaftaran Gagal", Colors.redAccent);
      }
    } catch (e) {
      // Error jika koneksi gagal (IP salah atau server mati)
      _showMessage("Gagal terhubung ke server Laravel", Colors.orange);
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Daftar Akun elebuddy"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginHorizontal),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text('Buat Profil Baru', style: AppTextStyle.brandTitle),
            const SizedBox(height: 20),

            // --- BAGIAN ORANG TUA ---
            _buildSectionHeader("Data Orang Tua"),
            CustomInput(
              controller: parentNameController,
              hint: 'Nama Ayah / Bunda',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),
            CustomInput(
              controller: emailController,
              hint: 'Email Aktif',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 15),
            CustomInput(
              controller: passwordController,
              hint: 'Kata Sandi',
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 30),

            // --- BAGIAN ANAK ---
            _buildSectionHeader("Data Anak"),
            CustomInput(
              controller: childNameController,
              hint: 'Nama Panggilan Anak',
              icon: Icons.child_care_rounded,
            ),
            const SizedBox(height: 15),
            CustomInput(
              controller: childAgeController,
              hint: 'Usia Anak (Tahun)',
              icon: Icons.cake_outlined,
            ),

            const SizedBox(height: 40),

            // Tombol Register
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSpacing.borderRadius,
                    ),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk judul seksi
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.purple,
          fontSize: 14,
        ),
      ),
    );
  }
}
