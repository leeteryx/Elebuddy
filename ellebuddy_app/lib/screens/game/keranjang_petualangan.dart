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
  }

  @override
  void dispose() {
    _feedbackController.dispose();
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

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      if (_currentIndex < _questionsShuffled.length - 1) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _isCorrect = false;
        });
        _feedbackController.reset();
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
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _buildResult();
    return _buildGame();
  }

  // ─── GAME ─────────────────────────────────────────

  Widget _buildGame() {
    final q = _questionsShuffled[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5C2E0),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            Text(
              'Soal ${_currentIndex + 1} / ${_questionsShuffled.length}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            Text(
              q.question,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Image.asset(
              q.strukImage,
              height: 200,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.receipt_long, size: 100),
            ),

            const SizedBox(height: 20),

            _buildOptions(q),

            const Spacer(),

            if (_answered)
              ScaleTransition(
                scale: _feedbackScale,
                child: Text(
                  _isCorrect ? '⭐' : '❌',
                  style: const TextStyle(fontSize: 80),
                ),
              ),

            const SizedBox(height: 20),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5C2E0),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'GOOD JOB!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text('$_stars / ${_questions.length} benar'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _restart,
                child: const Text('Main Lagi'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── TOP BAR (SUDAH DISAMAKAN) ───────────────────────

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
