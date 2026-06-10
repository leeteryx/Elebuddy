import 'package:flutter/material.dart';
import 'dart:math';
import '../../services/api_service.dart';

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
      situasi: 'Temanmu sedang berkelahi, apa yang harus kamu lakukan?',
      gambarSoal: 'images/berantem.png',
      gambarBenar: 'images/melerai.png',
      gambarSalah: ['images/mendukung.png', 'images/malahnangis.png'],
    ),
    SosialItem(
      situasi:
          'Kamu membawa makanan lebih sedangkan temanmu tidak, apa yang harus kamu lakukan? ',
      gambarSoal: 'images/puzzleliatanakmakan.png',
      gambarBenar: 'images/puzzlebagimakanan.png',
      gambarSalah: ['images/puzzlegmaubagi.png', 'images/puzzlesembunyi.png'],
    ),
    SosialItem(
      situasi: 'Setelah bermain, apa yang harus kamu lakukan?',
      gambarSoal: 'images/puzzle_main.png',
      gambarBenar: 'images/puzzle_beresin.png',
      gambarSalah: ['images/puzzle_ninggalin.png', 'images/puzzle_injak.png'],
    ),
    SosialItem(
      situasi:
          'Melihat kakek ingin menyeberang jalan, apa yang harus kamu lakukan?',
      gambarSoal: 'images/puzzlekakeknyebrang.png',
      gambarBenar: 'images/puzzlebantunyebrang.png',
      gambarSalah: [
        'images/puzzledorongkakek.png',
        'images/puzzlegamaubantu.png',
      ],
    ),
    SosialItem(
      situasi: 'Melihat temanmu terjatuh, apa yang harus kamu lakukan?',
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

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    _starCtrl.dispose();
    super.dispose();
  }

  void _shuffleChoices() {
    final item = items[_currentIndex];
    final choices = [item.gambarBenar, ...item.gambarSalah];
    choices.shuffle(Random());
    setState(() {
      _choices = choices;
    });
  }

  Future<void> _saveScore(int finalScore) async {
    try {
      final response = await ApiService.saveGameScore(
        "Puzzle Sosial",
        finalScore,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Sukses: Skor $finalScore berhasil disimpan ke Laravel!');
      } else {
        debugPrint(
          'Gagal menyimpan: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error koneksi saat menyimpan skor: $e');
    }
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
        _saveScore(_stars);
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'EleBuddy',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  Image.asset('images/elephant_ball.png', height: 36),
                ],
              ),
              const SizedBox(height: 4),
              Text('Soal ${_currentIndex + 1} / ${items.length}'),
            ],
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ✅ FINISH SCREEN
  Widget _buildFinish() {
    String message = 'Bagus sekali! 🎉';
    if (_stars == items.length) {
      message = 'Luar biasa! Sempurna! 🌟';
    } else if (_stars == 0) {
      message = 'Yuk coba lagi! 💪';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFE082),
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
                    'Kamu dapat $_stars dari ${items.length} benar!',
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),

                  const SizedBox(height: 30),

                  // ✅ BINTANG DINAMIS FINISH
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final starSize =
                            (constraints.maxWidth / items.length - 12).clamp(
                              24.0,
                              52.0,
                            );

                        return Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          runSpacing: 6,
                          children: List.generate(items.length, (i) {
                            return Icon(
                              i < _stars ? Icons.star : Icons.star_border,
                              size: starSize,
                              color: i < _stars
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
                        backgroundColor: const Color(0xFFF9C846),
                        foregroundColor: Colors.black87,
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
                        'Selesai',
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

        const SizedBox(height: 8),

        // ✅ PROGRESS BINTANG DINAMIS - di bawah situasi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final starSize = (constraints.maxWidth / items.length - 12).clamp(
                18.0,
                28.0,
              );

              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: List.generate(items.length, (i) {
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

        SizedBox(
          height: screenHeight * 0.30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(item.gambarSoal),
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

        // Layout 2 atas + 1 bawah
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChoiceButton(_choices[0]),
                  const SizedBox(width: 16),
                  _buildChoiceButton(_choices[1]),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_buildChoiceButton(_choices[2])],
              ),
            ],
          ),
        ),

        const Spacer(),
      ],
    );
  }

  Widget _buildChoiceButton(String gambar) {
    return GestureDetector(
      onTap: _answered ? null : () => _onAnswer(gambar),
      child: Container(
        width: 130,
        height: 115,
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
