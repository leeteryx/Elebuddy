import 'package:flutter/material.dart';
import 'dart:math';

class SosialItem {
  final String situasi;
  final String gambarSoal;
  final String gambarBenar;
  const SosialItem({
    required this.situasi,
    required this.gambarSoal,
    required this.gambarBenar,
  });
}

class PuzzleSosialPage extends StatefulWidget {
  const PuzzleSosialPage({super.key});

  @override
  State<PuzzleSosialPage> createState() => _PuzzleSosialPageState();
}

class _PuzzleSosialPageState extends State<PuzzleSosialPage>
    with TickerProviderStateMixin {
  final List<SosialItem> items = [
    SosialItem(
      situasi: 'Teman sedang menangis',
      gambarSoal: 'images/sosial_nangis.png',
      gambarBenar: 'images/sosial_peluk.png',
    ),
    SosialItem(
      situasi: 'Teman jatuh',
      gambarSoal: 'images/sosial_jatuh.png',
      gambarBenar: 'images/sosial_bantu.png',
    ),
    SosialItem(
      situasi: 'Bingung',
      gambarSoal: 'images/puzzle_bingung.png',
      gambarBenar: 'images/puzzle_bantu_bingung.png',
    ),
  ];

  List<String> _choices = [];

  int _currentIndex = 0;
  int _stars = 0;
  bool _answered = false;
  bool _isCorrect = false;
  bool _gameFinished = false;

  late AnimationController _feedbackCtrl;
  late Animation<double> _feedbackScale;
  late AnimationController _starCtrl;
  late Animation<double> _starScale;

  @override
  void initState() {
    super.initState();

    _feedbackCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _feedbackScale = CurvedAnimation(
      parent: _feedbackCtrl,
      curve: Curves.elasticOut,
    );

    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _starScale = CurvedAnimation(parent: _starCtrl, curve: Curves.elasticOut);

    _shuffleChoices();
  }

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    _starCtrl.dispose();
    super.dispose();
  }

  void _shuffleChoices() {
    final allAnswers = items.map((e) => e.gambarBenar).toList();
    final correct = items[_currentIndex].gambarBenar;

    final wrongs = allAnswers.where((g) => g != correct).toList()
      ..shuffle(Random());
    final choices = [correct, ...wrongs.take(2)];
    choices.shuffle(Random());

    setState(() {
      _choices = choices;
    });
  }

  void _onAnswer(String selected) {
    if (_answered) return;
    final correct = selected == items[_currentIndex].gambarBenar;

    setState(() {
      _answered = true;
      _isCorrect = correct;
      if (correct) _stars++;
    });

    _feedbackCtrl.forward(from: 0);
    if (correct) _starCtrl.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      if (_currentIndex < items.length - 1) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _isCorrect = false;
        });
        _shuffleChoices();
        _feedbackCtrl.reset();
        _starCtrl.reset();
      } else {
        setState(() => _gameFinished = true);
      }
    });
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _stars = 0;
      _answered = false;
      _isCorrect = false;
      _gameFinished = false;
    });
    _feedbackCtrl.reset();
    _starCtrl.reset();
    _shuffleChoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE082),
      body: SafeArea(child: _gameFinished ? _buildFinish() : _buildGame()),
    );
  }

  // 🔥 TOP BAR SAMA SEPERTI SEBELUMNYA
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
          const SizedBox(width: 48), // biar balance kanan-kiri
        ],
      ),
    );
  }

  // ─── FINISH ─────────────────────────────────────────────
  Widget _buildFinish() {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'GOOD JOB!!!',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    items.length,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        i < _stars ? '⭐' : '☆',
                        style: const TextStyle(fontSize: 42),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('$_stars dari ${items.length} benar!'),
                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _actionButton(
                      'Main Lagi',
                      const Color(0xFFF9C846),
                      _restart,
                    ),
                    const SizedBox(width: 16),
                    _actionButton(
                      'Selesai',
                      Colors.white,
                      () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(label),
    );
  }

  // ─── GAME ─────────────────────────────────────────────
  Widget _buildGame() {
    final item = items[_currentIndex];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = (screenWidth - 24 * 2 - 12 * 2) / 3;

    return Column(
      children: [
        _buildTopBar(),

        Text(
          'Soal ${_currentIndex + 1} / ${items.length}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          item.situasi,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),
        const Text('Apa yang harus dilakukan?'),

        SizedBox(
          height: screenHeight * 0.32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Image.asset(item.gambarSoal),
              ),
              if (_answered)
                ScaleTransition(
                  scale: _feedbackScale,
                  child: Text(
                    _isCorrect ? '⭐' : '❌',
                    style: const TextStyle(fontSize: 110),
                  ),
                ),
            ],
          ),
        ),

        Container(
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          color: Colors.black12,
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildChoiceButton(_choices[0], cardSize),
              _buildChoiceButton(_choices[1], cardSize),
              _buildChoiceButton(_choices[2], cardSize),
            ],
          ),
        ),

        const Spacer(),

        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (i) {
              final earned = i < _stars;
              final isLatest = earned && i == _stars - 1;
              return ScaleTransition(
                scale: isLatest
                    ? _starScale
                    : const AlwaysStoppedAnimation(1.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    earned ? '⭐' : '☆',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceButton(String gambar, double size) {
    return GestureDetector(
      onTap: _answered ? null : () => _onAnswer(gambar),
      child: Container(
        width: size,
        height: size * 0.85,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(gambar, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
