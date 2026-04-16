import 'package:flutter/material.dart';
import '../../widgets/constants.dart';
import '../../data/question_data.dart'; // File bank soal yang kita buat sebelumnya
import 'result_screen.dart'; // File hasil skrining

class ScreenerScreen extends StatefulWidget {
  const ScreenerScreen({super.key});

  @override
  State<ScreenerScreen> createState() => _ScreenerScreenState();
}

class _ScreenerScreenState extends State<ScreenerScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Variabel untuk menyimpan skor/jawaban (logika sederhana)
  int _totalYesScore = 0;

  void _handleAnswer(dynamic answer) {
    // Logika penilaian sederhana: Jika jawaban adalah 'YA', tambah skor
    if (answer == "YA") {
      _totalYesScore++;
    }

    // Jika masih ada pertanyaan selanjutnya
    if (_currentIndex < screenerQuestions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Jika sudah pertanyaan terakhir, arahkan ke halaman hasil
      _navigateToResult();
    }
  }

  void _navigateToResult() {
    String status;
    // Logika penentuan hasil berdasarkan jumlah jawaban 'YA'
    if (_totalYesScore >= 3) {
      status = 'excellent';
    } else if (_totalYesScore >= 1) {
      status = 'warning';
    } else {
      status = 'danger';
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(status: status)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung progress indicator (0.0 sampai 1.0)
    double progressValue = (_currentIndex + 1) / screenerQuestions.length;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR: Back Button & Progress Bar
            _buildTopBar(progressValue),

            // MAIN CONTENT: PageView untuk pertanyaan
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // User tidak bisa swipe manual
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: screenerQuestions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionContent(screenerQuestions[index]);
                },
              ),
            ),

            // FOOTER: Logo ElleBuddy
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primary,
            ),
            onPressed: () {
              if (_currentIndex > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(Question question) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Kategori (Preliminary, Cognitive, dll)
          Text(
            question.category,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
              fontFamily: 'Comic Sans MS', // Gunakan font playful jika ada
            ),
          ),
          const SizedBox(height: 20),

          // Gambar Ilustrasi Gajah
          Image.asset(
            question.imagePath,
            height: 150,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image, size: 100, color: Colors.grey),
          ),

          const SizedBox(height: 30),

          // Teks Pertanyaan
          Text(
            question.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),

          if (question.subText != null) ...[
            const SizedBox(height: 10),
            Text(
              question.subText!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
            ),
          ],

          const SizedBox(height: 40),

          // Render Tombol Jawaban Berdasarkan Tipe Pertanyaan
          _buildAnswerButtons(question),
        ],
      ),
    );
  }

  Widget _buildAnswerButtons(Question question) {
    if (question.type == QuestionType.yesNo) {
      return Column(
        children: [
          _buildActionButton("YA", () => _handleAnswer("YA")),
          const SizedBox(height: 15),
          _buildActionButton("TIDAK", () => _handleAnswer("TIDAK")),
        ],
      );
    } else {
      // Untuk tipe singleChoice atau ageSelection
      return Column(
        children: question.options!.map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _handleAnswer(option),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  option,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: 200,
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            "ElleBuddy",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Image.asset('images/elephant.png', height: 35),
        ],
      ),
    );
  }
}
