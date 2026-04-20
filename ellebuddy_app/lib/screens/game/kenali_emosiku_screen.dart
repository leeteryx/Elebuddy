import 'package:flutter/material.dart';

// ─── DATA MODEL ───────────────────────────────────────────────────────────────

class MoodQuestion {
  final String id;
  final String mood;
  final String imagePath;
  final String correctEmojiImage;
  final String wrongEmojiImage;

  const MoodQuestion({
    required this.id,
    required this.mood,
    required this.imagePath,
    required this.correctEmojiImage,
    required this.wrongEmojiImage,
  });
}

// ─── DATA SOAL ────────────────────────────────────────────────────────────────

final List<MoodQuestion> moodQuestions = [
  MoodQuestion(
    id: 'mq1',
    mood: 'Marah',
    imagePath: 'images/marah.png',
    correctEmojiImage: 'images/emomarah.png',
    wrongEmojiImage: 'images/emosenang.png',
  ),
  MoodQuestion(
    id: 'mq2',
    mood: 'Senang',
    imagePath: 'images/senang.png',
    correctEmojiImage: 'images/emosenang.png',
    wrongEmojiImage: 'images/emonangis.png',
  ),
  MoodQuestion(
    id: 'mq3',
    mood: 'Sedih',
    imagePath: 'images/nangis.png',
    correctEmojiImage: 'images/emonangis.png',
    wrongEmojiImage: 'images/emotakut.png',
  ),
  MoodQuestion(
    id: 'mq4',
    mood: 'Takut',
    imagePath: 'images/takut.png',
    correctEmojiImage: 'images/emotakut.png',
    wrongEmojiImage: 'images/emokaget.png',
  ),
  MoodQuestion(
    id: 'mq5',
    mood: 'Kaget',
    imagePath: 'images/kaget.png',
    correctEmojiImage: 'images/emokaget.png',
    wrongEmojiImage: 'images/emomarah.png',
  ),
  MoodQuestion(
    id: 'mq6',
    mood: 'Malu',
    imagePath: 'images/anak_malu.png',
    correctEmojiImage: 'images/emosi_malu.png',
    wrongEmojiImage: 'images/emosi_bingung.png',
  ),
  MoodQuestion(
    id: 'mq7',
    mood: 'Bingung',
    imagePath: 'images/anak_bingung.png',
    correctEmojiImage: 'images/emosi_bingung.png',
    wrongEmojiImage: 'images/emosi_malu.png',
  ),
  MoodQuestion(
    id: 'mq8',
    mood: 'Terkejut',
    imagePath: 'images/anak_terkejut.png',
    correctEmojiImage: 'images/emosi_terkejut.png',
    wrongEmojiImage: 'images/emosi_malu.png',
  ),
];

// ─── SCREEN ───────────────────────────────────────────────────────────────────

class KenaliEmosikuScreen extends StatefulWidget {
  const KenaliEmosikuScreen({super.key});

  @override
  State<KenaliEmosikuScreen> createState() => _KenaliEmosikuScreenState();
}

class _KenaliEmosikuScreenState extends State<KenaliEmosikuScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _stars = 0;
  bool _answered = false;
  bool _isCorrect = false;
  bool _gameFinished = false;
  late List<String> _choices;

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
    final q = moodQuestions[_currentIndex];
    _choices = [q.correctEmojiImage, q.wrongEmojiImage]..shuffle();
  }

  void _onAnswer(String emojiImagePath) {
    if (_answered) return;
    final q = moodQuestions[_currentIndex];
    final correct = emojiImagePath == q.correctEmojiImage;

    setState(() {
      _answered = true;
      _isCorrect = correct;
      if (correct) _stars++;
    });

    _feedbackCtrl.forward(from: 0);
    if (correct) _starCtrl.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      if (_currentIndex < moodQuestions.length - 1) {
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

    _shuffleChoices();
    _feedbackCtrl.reset();
    _starCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC1F9D2),
      body: SafeArea(child: _gameFinished ? _buildFinish() : _buildGame()),
    );
  }

  // ─── TOP BAR (UPDATED) ──────────────────────────────────────────────────────

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
          // Bagian Tengah: Judul dan Progress Soal
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
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
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.pets, size: 36),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ), // Jarak sedikit antara nama dan nomor soal
              Text(
                'Soal ${_currentIndex + 1} / ${moodQuestions.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Spacer untuk menyeimbangkan posisi tengah karena ada tombol back di kiri
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ─── FINISH ─────────────────────────────────────────────────────────────────

  Widget _buildFinish() {
    final stars = _stars;

    // Pesan berdasarkan jumlah bintang
    String message = 'Bagus sekali! 🎉';
    if (stars == moodQuestions.length) {
      message = 'Luar biasa! Sempurna! 🌟';
    } else if (stars == 0) {
      message = 'Yuk coba lagi! 💪';
    }

    return Scaffold(
      backgroundColor: const Color(
        0xFFC1F9D2,
      ), // Warna hijau asli tetap dipertahankan
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(), // Menampilkan TopBar konsisten

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Maskot Gajah Tengah
                  Image.asset(
                    'images/elephant_ball.png',
                    height: 180,
                    errorBuilder: (_, __, ___) =>
                        const Text('🐘', style: TextStyle(fontSize: 100)),
                  ),

                  const SizedBox(height: 30),

                  // Teks Pesan Utama
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Sub-teks statistik
                  Text(
                    'Kamu dapat $stars dari ${moodQuestions.length} benar!',
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),

                  const SizedBox(height: 30),

                  // Barisan Bintang Besar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(moodQuestions.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          i < stars ? Icons.star : Icons.star_border,
                          size: 52,
                          color: i < stars
                              ? Colors.amber
                              : Colors.white.withOpacity(0.6),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Bagian Tombol di Bawah (Dibuat memanjang sesuai gambar referensi)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                children: [
                  // Tombol Main Lagi
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _restart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFF9C846,
                        ), // Warna kuning tombol asli
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

                  // Tombol Selesai/Kembali
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

  // ─── GAME ───────────────────────────────────────────────────────────────────

  Widget _buildGame() {
    final q = moodQuestions[_currentIndex];

    return Column(
      children: [
        _buildTopBar(), // 🔥 sudah diganti

        Expanded(
          flex: 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Image.asset(q.imagePath),
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

        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _choices.map(_buildEmojiButton).toList(),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(moodQuestions.length, (i) {
              final earned = i < _stars;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  earned ? '⭐' : '☆',
                  style: const TextStyle(fontSize: 30),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiButton(String emojiImagePath) {
    return GestureDetector(
      onTap: () => _onAnswer(emojiImagePath),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(emojiImagePath),
        ),
      ),
    );
  }
}
