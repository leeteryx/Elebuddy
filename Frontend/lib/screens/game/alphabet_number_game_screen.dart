// lib/screens/game/alphabet_number_game_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/alphabet_number_data.dart';

class AlphabetNumberGameScreen extends StatefulWidget {
  const AlphabetNumberGameScreen({super.key});

  @override
  State<AlphabetNumberGameScreen> createState() =>
      _AlphabetNumberGameScreenState();
}

class _AlphabetNumberGameScreenState extends State<AlphabetNumberGameScreen>
    with TickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();

  bool _isAlphabetMode = true;
  int? _selectedIndex;
  bool _isSpeaking = false;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  // Mapping icon FontAwesome untuk huruf
  static final Map<String, IconData> alphabetIcons = {
    'A': FontAwesomeIcons.apple,
    'B': FontAwesomeIcons.book,
    'C': FontAwesomeIcons.bug,
    'D': FontAwesomeIcons.hippo,
    'E': FontAwesomeIcons.dove,
    'F': FontAwesomeIcons.camera,
    'G': FontAwesomeIcons.horse,
    'H': FontAwesomeIcons.cat,
    'I': FontAwesomeIcons.fish,
    'J': FontAwesomeIcons.horse,
    'K': FontAwesomeIcons.cat,
    'L': FontAwesomeIcons.paw,
    'M': FontAwesomeIcons.sun,
    'N': FontAwesomeIcons.leaf,
    'O': FontAwesomeIcons.water,
    'P': FontAwesomeIcons.tree,
    'Q': FontAwesomeIcons.flag,
    'R': FontAwesomeIcons.dog,
    'S': FontAwesomeIcons.crown,
    'T': FontAwesomeIcons.paw,
    'U': FontAwesomeIcons.shrimp,
    'V': FontAwesomeIcons.music,
    'W': FontAwesomeIcons.carrot,
    'X': FontAwesomeIcons.music,
    'Y': FontAwesomeIcons.glassWater,
    'Z': FontAwesomeIcons.horse,
  };

  // Mapping icon FontAwesome untuk angka
  static final Map<String, IconData> numberIcons = {
    '0': FontAwesomeIcons.ban,
    '1': FontAwesomeIcons.apple,
    '2': FontAwesomeIcons.star,
    '3': FontAwesomeIcons.futbol,
    '4': FontAwesomeIcons.hippo,
    '5': FontAwesomeIcons.hand,
    '6': FontAwesomeIcons.egg,
    '7': FontAwesomeIcons.cloudSun,
    '8': FontAwesomeIcons.spider,
    '9': FontAwesomeIcons.globe,
    '10': FontAwesomeIcons.hands,
  };

  @override
  void initState() {
    super.initState();
    _initTts();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('id-ID');
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.1);
    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speak(AlphabetNumberItem item, int index) async {
    if (_isSpeaking) await _flutterTts.stop();
    setState(() {
      _selectedIndex = index;
      _isSpeaking = true;
    });
    _bounceController.forward().then((_) => _bounceController.reverse());
    await _flutterTts.speak('${item.name}. ${item.example}');
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _isAlphabetMode
        ? AlphabetNumberData.alphabets
        : AlphabetNumberData.numbers;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildModeToggle(),
          if (_selectedIndex != null) _buildSelectedCard(items),
          Expanded(child: _buildGrid(items)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF6C63FF),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Belajar Huruf & Angka',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE8FF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: _toggleButton('Huruf', FontAwesomeIcons.font, true),
            ),
            Expanded(
              child: _toggleButton('Angka', FontAwesomeIcons.hashnode, false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton(String label, IconData icon, bool isAlphabet) {
    final bool isActive = _isAlphabetMode == isAlphabet;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAlphabetMode = isAlphabet;
          _selectedIndex = null;
        });
        _flutterTts.stop();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6C63FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 14,
              color: isActive ? Colors.white : const Color(0xFF6C63FF),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF6C63FF),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedCard(List<AlphabetNumberItem> items) {
    final item = items[_selectedIndex!];
    final iconData = _isAlphabetMode
        ? alphabetIcons[item.symbol]
        : numberIcons[item.symbol];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9B8FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Big Symbol
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                item.symbol,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (iconData != null)
                      FaIcon(iconData, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      item.example,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Speaker icon
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: FaIcon(
              _isSpeaking
                  ? FontAwesomeIcons.volumeHigh
                  : FontAwesomeIcons.volumeLow,
              key: ValueKey(_isSpeaking),
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<AlphabetNumberItem> items) {
    final crossAxisCount = _isAlphabetMode ? 4 : 3;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: _isAlphabetMode ? 0.78 : 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = _selectedIndex == index;
        return _buildItemCard(item, index, isSelected);
      },
    );
  }

  Widget _buildItemCard(AlphabetNumberItem item, int index, bool isSelected) {
    final List<List<Color>> gradients = [
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFFA18CD1), const Color(0xFFFBC2EB)],
      [const Color(0xFFFED6A3), const Color(0xFFF7971E)],
      [const Color(0xFF89F7FE), const Color(0xFF66A6FF)],
      [const Color(0xFFCFDEF3), const Color(0xFFE0C3FC)],
    ];
    final gradient = gradients[index % gradients.length];

    final iconData = _isAlphabetMode
        ? alphabetIcons[item.symbol]
        : numberIcons[item.symbol];

    return GestureDetector(
      onTap: () => _speak(item, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: isSelected
            ? (Matrix4.identity()..scale(1.06))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [const Color(0xFF6C63FF), const Color(0xFF9B8FFF)]
                : gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: (isSelected ? const Color(0xFF6C63FF) : gradient[0])
                  .withOpacity(0.4),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.white, width: 2.5)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null)
              FaIcon(
                iconData,
                size: _isAlphabetMode ? 18 : 22,
                color: Colors.white.withOpacity(0.95),
              ),
            SizedBox(height: _isAlphabetMode ? 3 : 4),
            Text(
              item.symbol,
              style: TextStyle(
                fontSize: _isAlphabetMode ? 26 : 34,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(1, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: _isAlphabetMode ? 2 : 3),
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _isAlphabetMode ? 9 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
