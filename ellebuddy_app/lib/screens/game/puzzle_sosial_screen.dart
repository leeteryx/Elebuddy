import 'package:flutter/material.dart';
import 'dart:math';

class SosialItem {
  final String situasi;
  final String gambarSoal;
  final String gambarBenar;
  final List<String> gambarSalah;

  const SosialItem({
    required this.situasi,
    required this.gambarSoal,
    required this.gambarBenar,
    required this.gambarSalah,
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
      situasi: 'Temanmu sedang berkelahi',
      gambarSoal: 'images/berantem.png',
      gambarBenar: 'images/melerai.png',
      gambarSalah: ['images/mendukung.png', 'images/malahnangis.png'],
    ),
    SosialItem(
      situasi: 'Kamu membawa makanan lebih sedangkan temanmu tidak ',
      gambarSoal: 'images/puzzleliatanakmakan.png',
      gambarBenar: 'images/puzzlebagimakanan.png',
      gambarSalah: ['images/puzzlegmaubagi.jpeg', 'images/puzzlesembunyi.png'],
    ),
    SosialItem(
      situasi: 'Setelah bermain',
      gambarSoal: 'images/puzzle_main.jpeg',
      gambarBenar: 'images/puzzle_beresin.png',
      gambarSalah: ['images/puzzle_ninggalin.png', 'images/puzzle_injak.jpeg'],
    ),
    SosialItem(
      situasi: 'Melihat kakek ingin menyeberang jalan',
      gambarSoal: 'images/puzzlekakeknyebrang.png',
      gambarBenar: 'images/puzzlebantunyebrang.png',
      gambarSalah: [
        'images/puzzledorongkakek.png',
        'images/puzzlegamaubantu.png',
      ],
    ),
    SosialItem(
      situasi: 'Melihat temanmu terjatuh',
      gambarSoal: 'images/puzzlejatuh.png',
      gambarBenar: 'images/puzzlebantujatuh.png',
      gambarSalah: ['images/puzzlediketawain.png', 'images/puzzlengefoto.png'],
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

  void _shuffleChoices() {
    final item = items[_currentIndex];
    final choices = [item.gambarBenar, ...item.gambarSalah];
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

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    'EleBuddy',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  Image.asset('images/elephant_ball.png', height: 36),
                ],
              ),
              Text('Soal ${_currentIndex + 1} / ${items.length}'),
            ],
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ✅ FINISH SAMA SEPERTI GAME KAMU
  Widget _buildFinish() {
    final messages = [
      'Yuk coba lagi! 💪',
      'Hampir! 🌈',
      'Bagus! 🎉',
      'Luar biasa! 🌟',
      'Sempurna! 🏆',
    ];

    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  messages[_stars.clamp(0, messages.length - 1)],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('$_stars dari ${items.length} benar'),
                const SizedBox(height: 24),

                // ⭐ BINTANG ICON
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(items.length, (i) {
                    return Icon(
                      i < _stars ? Icons.star : Icons.star_border,
                      size: 42,
                      color: i < _stars ? Colors.amber : Colors.grey,
                    );
                  }),
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _restart,
                  child: const Text('Main Lagi'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGame() {
    final item = items[_currentIndex];
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        _buildTopBar(),
        const SizedBox(height: 8),

        Text(
          item.situasi,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        SizedBox(
          height: screenHeight * 0.32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(item.gambarSoal),

              // ⭐ / ❌ FEEDBACK
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

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _choices.length,
              (i) => _buildChoiceButton(_choices[i]),
            ),
          ),
        ),

        const Spacer(),

        // ⭐ PROGRESS BINTANG
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (i) {
              final earned = i < _stars;
              return ScaleTransition(
                scale: (earned && i == _stars - 1)
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

  Widget _buildChoiceButton(String gambar) {
    return GestureDetector(
      onTap: _answered ? null : () => _onAnswer(gambar),
      child: Container(
        width: 100,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(gambar),
        ),
      ),
    );
  }
}
