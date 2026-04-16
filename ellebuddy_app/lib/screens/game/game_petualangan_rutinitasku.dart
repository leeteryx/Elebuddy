import 'package:flutter/material.dart';
import 'dart:math';

class GameItem {
  final String nama;
  final String gambar;
  const GameItem(this.nama, this.gambar);
}

class PetualanganRutinitaskuPage extends StatefulWidget {
  const PetualanganRutinitaskuPage({super.key});

  @override
  State<PetualanganRutinitaskuPage> createState() =>
      _PetualanganRutinitaskuState();
}

class _PetualanganRutinitaskuState extends State<PetualanganRutinitaskuPage>
    with TickerProviderStateMixin {
  final List<GameItem> items = [
    GameItem('Bangun Tidur', 'images/bangun_tidur.png'),
    GameItem('Sarapan', 'images/sarapan.png'),
    GameItem('Menyapu', 'images/menyapu.png'),
    GameItem('Sikat Gigi', 'images/sikat_gigi.png'),
  ];

  int _currentIndex = 0;
  int _stars = 0;
  bool _answered = false;
  bool _isCorrect = false;
  bool _gameFinished = false;
  late List<GameItem> _choices;

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
    _choices = List.from(items)..shuffle(Random());
  }

  void _onAnswer(String selectedGambar) {
    if (_answered) return;
    final correct = selectedGambar == items[_currentIndex].gambar;

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
          _shuffleChoices();
        });
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
      _shuffleChoices();
    });
    _feedbackCtrl.reset();
    _starCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea(child: _gameFinished ? _buildFinish() : _buildGame()),
    );
  }

  // ─── FINISH ───────────────────────────────────────────────────────────────

  Widget _buildFinish() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'GOOD JOB!!!',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
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
          Text(
            '$_stars dari ${items.length} benar!',
            style: const TextStyle(fontSize: 18, color: Color(0xFF555555)),
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton('Main Lagi', const Color(0xFFF9C846), _restart),
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
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 4,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ─── GAME ─────────────────────────────────────────────────────────────────

  Widget _buildGame() {
    final item = items[_currentIndex];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = (screenWidth - 24 * 2 - 12) / 2;

    return Column(
      children: [
        // TOP BAR
        Padding(
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
              Text(
                'Soal ${_currentIndex + 1} / ${items.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),

        // NAMA KEGIATAN
        Text(
          item.nama,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),

        // GAMBAR UTAMA + FEEDBACK
        SizedBox(
          height: screenHeight * 0.35,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Image.asset(item.gambar, fit: BoxFit.contain),
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

        // DIVIDER
        Container(
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          color: Colors.black12,
        ),

        const SizedBox(height: 16),

        // PILIHAN 2x2 — diperbesar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                children: [
                  _buildChoiceButton(_choices[0], cardSize),
                  const SizedBox(width: 12),
                  _buildChoiceButton(_choices[1], cardSize),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildChoiceButton(_choices[2], cardSize),
                  const SizedBox(width: 12),
                  _buildChoiceButton(_choices[3], cardSize),
                ],
              ),
            ],
          ),
        ),

        // BINTANG — di bagian bawah layar seperti KenaliEmosiku
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

  // ─── CHOICE BUTTON ────────────────────────────────────────────────────────

  Widget _buildChoiceButton(GameItem opt, double size) {
    return GestureDetector(
      onTap: () => _onAnswer(opt.gambar),
      child: Container(
        width: size,
        height: size * 0.85, // ← lebih tinggi dari sebelumnya (0.75 → 0.85)
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(opt.gambar, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
