import 'package:flutter/material.dart';

class ScreeningResult {
  final String title;
  final String description;
  final String subDescription;
  final String imagePath;
  final Color themeColor;

  ScreeningResult({
    required this.title,
    required this.description,
    required this.subDescription,
    required this.imagePath,
    required this.themeColor,
  });
}

// Data statis untuk masing-masing kondisi
final Map<String, ScreeningResult> resultOptions = {
  'excellent': ScreeningResult(
    title:
        "Hebat! Perkembangan si kecil saat ini sudah sesuai dengan tahapan usianya",
    description:
        "Tetap berikan stimulasi melalui game di elebuddy untuk menjaga progresnya!",
    subDescription: "", // Kosongkan jika tidak ada
    imagePath: "images/result_excellent.png",
    themeColor: const Color(0xFF23A1B1),
  ),
  'warning': ScreeningResult(
    title:
        "Si kecil menunjukkan progres yang baik, namun ada beberapa area yang perlu perhatian ekstra!",
    description:
        "Yuk, ajak si kecil bermain lebih sering di menu game untuk bantu asah kemampuannya jadi makin oke!",
    subDescription: "",
    imagePath: "images/result_warning.png",
    themeColor: const Color(0xFFF9A825),
  ),
  'danger': ScreeningResult(
    title:
        "elebuddy menyarankan Ayah/Bunda untuk melakukan konsultasi lebih lanjut dengan tenaga profesional",
    description:
        "Hasil ini adalah skrining awal, bukan diagnosis final. Segera buat janji dengan tenaga profesional.",
    subDescription: "",
    imagePath: "images/result_danger.png",
    themeColor: Colors.redAccent,
  ),
};
