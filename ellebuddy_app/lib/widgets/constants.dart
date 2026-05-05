import 'package:flutter/material.dart';

class AppColors {
  // Warna Utama elebuddy
  static const Color primary = Color(0xFF23A1B1); // Biru Toska
  static const Color accent = Color(0xFFF9A825); // Oranye
  static const Color background = Color(0xFFF5F7F8);
  static const Color purple = Color(0xFF9FA8DA);
  static const Color white = Colors.white;
}

class AppSpacing {
  static const double marginHorizontal = 25.0;
  static const double borderRadius = 20.0;
}

class AppTextStyle {
  static const TextStyle header = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle brandTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.purple,
    letterSpacing: 1.2,
  );
}
