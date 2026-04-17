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
    wrongEmojiImage: 'images/emomarah.png',
  ),
  MoodQuestion(
    id: 'mq4',
    mood: 'Takut',
    imagePath: 'images/takut.png',
    correctEmojiImage: 'images/emotakut.png',
    wrongEmojiImage: 'images/emosenang.png',
  ),
  MoodQuestion(
    id: 'mq5',
    mood: 'Kaget',
    imagePath: 'images/kaget.png',
    correctEmojiImage: 'images/emokaget.png',
    wrongEmojiImage: 'images/emomarah.png',
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
        ],
      ),
    );
  }

  // ─── FINISH ─────────────────────────────────────────────────────────────────

  Widget _buildFinish() {
    return Center(
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
              moodQuestions.length,
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
          Text('$_stars dari ${moodQuestions.length} benar!'),
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
      ),
      child: Text(label),
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
