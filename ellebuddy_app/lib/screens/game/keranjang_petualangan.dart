import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// ─── MODEL ─────────────────────────────────────────────

class QuizOption {
  final String text;
  final String? image;
  final bool isCorrect;

  const QuizOption({required this.text, this.image, required this.isCorrect});
}

class QuizQuestion {
  final String question;
  final String strukImage;
  final List<QuizOption> options;

  const QuizQuestion({
    required this.question,
    required this.strukImage,
    required this.options,
  });
}

// ─── DATA SOAL ─────────────────────────────────────────

final List<QuizQuestion> _questions = [
  QuizQuestion(
    question: 'Apa yang ada di struk?',
    strukImage: 'images/struk roti sama keju.png',
    options: [
      QuizOption(text: 'Roti & Keju', isCorrect: true),
      QuizOption(text: 'Susu & Apel', isCorrect: false),
      QuizOption(text: 'Mangga & Semangka', isCorrect: false),
    ],
  ),
  QuizQuestion(
    question: 'Berapa harga apel?',
    strukImage: 'images/struk susu sama apel.png',
    options: [
      QuizOption(text: '2.50', isCorrect: true),
      QuizOption(text: '5.00', isCorrect: false),
      QuizOption(text: '1.00', isCorrect: false),
    ],
  ),
  QuizQuestion(
    question: 'Apa yang ada di struk?',
    strukImage: 'images/struk mangga semangka.png',
    options: [
      QuizOption(text: 'Mangga & Semangka', isCorrect: true),
      QuizOption(text: 'Roti & Keju', isCorrect: false),
      QuizOption(text: 'Susu & Apel', isCorrect: false),
    ],
  ),
  QuizQuestion(
    question: 'Berapa harga keju?',
    strukImage: 'images/struksusukejuroti.png',
    options: [
      QuizOption(text: '3.50', isCorrect: true),
      QuizOption(text: '1.00', isCorrect: false),
      QuizOption(text: '5.00', isCorrect: false),
    ],
  ),
  QuizQuestion(
    question: 'Ada berapa barang di struk?',
    strukImage: 'images/struklengkap.png',
    options: [
      QuizOption(text: '5', isCorrect: true),
      QuizOption(text: '3', isCorrect: false),
      QuizOption(text: '2', isCorrect: false),
    ],
  ),
  QuizQuestion(
    question: 'Berapa harga susu?',
    strukImage: 'images/struksusukejuroti.png',
    options: [
      QuizOption(text: '2.00', isCorrect: true),
      QuizOption(text: '4.00', isCorrect: false),
      QuizOption(text: '1.50', isCorrect: false),
    ],
  ),
];

// ─── MAIN SCREEN ───────────────────────────────────────

class KeranjangPetualanganScreen extends StatefulWidget {
  const KeranjangPetualanganScreen({super.key});

  @override
  State<KeranjangPetualanganScreen> createState() =>
      _KeranjangPetualanganScreenState();
}

class _KeranjangPetualanganScreenState extends State<KeranjangPetualanganScreen>
    with TickerProviderStateMixin {
  late List<QuizQuestion> _questionsShuffled;

  int _currentIndex = 0;
  int _stars = 0;
  bool _answered = false;
  bool _isCorrect = false;
  bool _finished = false;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;
  late AnimationController _starCtrl;
  late Animation<double> _starScale;

  @override
  void initState() {
    super.initState();

    _questionsShuffled = List.from(_questions)..shuffle(Random());

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _feedbackScale = CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.elasticOut,
    );

    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _starScale = CurvedAnimation(parent: _starCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _starCtrl.dispose();
    super.dispose();
  }

  void _onAnswer(bool correct) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _isCorrect = correct;
      if (correct) _stars++;
    });

    _feedbackController.forward(from: 0);
    if (correct) _starCtrl.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      if (_currentIndex < _questionsShuffled.length - 1) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _isCorrect = false;
        });
        _feedbackController.reset();
        _starCtrl.reset();
      } else {
        setState(() => _finished = true);
      }
    });
  }

  void _restart() {
    setState(() {
      _questionsShuffled = List.from(_questions)..shuffle();
      _currentIndex = 0;
      _stars = 0;
      _answered = false;
      _isCorrect = false;
      _finished = false;
    });
    _feedbackController.reset();
    _starCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _buildResult();
    return _buildGame();
  }

  // ─── GAME ─────────────────────────────────────────

  Widget _buildGame() {
    final q = _questionsShuffled[_currentIndex];
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5C2E0),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            // Soal + nomor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Soal ${_currentIndex + 1} / ${_questionsShuffled.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    q.question,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ✅ PROGRESS BINTANG DINAMIS - di bawah soal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final starSize =
                      (constraints.maxWidth / _questionsShuffled.length - 12)
                          .clamp(18.0, 28.0);

                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: List.generate(_questionsShuffled.length, (i) {
                      final earned = i < _stars;
                      return ScaleTransition(
                        scale: (earned && i == _stars - 1)
                            ? _starScale
                            : const AlwaysStoppedAnimation(1.0),
                        child: Text(
                          earned ? '⭐' : '☆',
                          style: TextStyle(fontSize: starSize),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Gambar struk
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.4,
                        ),
                        child: Image.asset(
                          q.strukImage,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.receipt_long, size: 100),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Pilihan jawaban
            _buildOptions(q),

            // Feedback bintang/silang
            SizedBox(
              height: 90,
              child: Center(
                child: _answered
                    ? ScaleTransition(
                        scale: _feedbackScale,
                        child: Text(
                          _isCorrect ? '⭐' : '❌',
                          style: const TextStyle(fontSize: 80),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(QuizQuestion q) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: q.options.map((opt) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: GestureDetector(
              onTap: _answered ? null : () => _onAnswer(opt.isCorrect),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: opt.image != null
                    ? Image.asset(
                        opt.image!,
                        height: 80,
                        errorBuilder: (_, __, ___) =>
                            Text(opt.text, textAlign: TextAlign.center),
                      )
                    : Text(
                        opt.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── RESULT ─────────────────────────────────────────

  Widget _buildResult() {
    final stars = _stars;

    String message = 'Bagus sekali! 🎉';
    if (stars == _questions.length) {
      message = 'Luar biasa! Sempurna! 🌟';
    } else if (stars == 0) {
      message = 'Yuk coba lagi! 💪';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5C2E0),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/elephant_ball.png',
                    height: 180,
                    errorBuilder: (_, __, ___) =>
                        const Text('🐘', style: TextStyle(fontSize: 100)),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Kamu dapat $stars dari ${_questions.length} benar!',
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),

                  const SizedBox(height: 30),

                  // ✅ BINTANG DINAMIS RESULT
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final starSize =
                            (constraints.maxWidth / _questions.length - 12)
                                .clamp(24.0, 52.0);

                        return Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          runSpacing: 6,
                          children: List.generate(_questions.length, (i) {
                            return Icon(
                              i < stars ? Icons.star : Icons.star_border,
                              size: starSize,
                              color: i < stars
                                  ? Colors.amber
                                  : Colors.white.withOpacity(0.6),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _restart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6EC6F5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Main Lagi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 2),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Kembali ke Menu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TOP BAR ───────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 24,
              color: Colors.black54,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Row(
            children: [
              const Text(
                'EleBuddy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              Image.asset(
                'images/elephant_ball.png',
                height: 36,
                errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 36),
              ),
            ],
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
