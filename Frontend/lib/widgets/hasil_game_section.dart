import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/game/hasil_game_detail_screen.dart';

class HasilGameSection extends StatefulWidget {
  const HasilGameSection({super.key});

  @override
  State<HasilGameSection> createState() => _HasilGameSectionState();
}

class _HasilGameSectionState extends State<HasilGameSection> {
  late Future<Map<String, int>> _gameResultsFuture;

  @override
  void initState() {
    super.initState();
    _gameResultsFuture = ApiService.getGameResults();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            "HASIL GAME",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        FutureBuilder<Map<String, int>>(
          future: _gameResultsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final results = snapshot.data ?? {};

            return Column(
              children: [
                _buildGameItem(
                  context,
                  "Petualangan Rutinitasku",
                  Icons.directions_run,
                  const Color(0xFF9ED0FF),
                  Colors.blue.shade700,
                  results,
                ),
                _buildGameItem(
                  context,
                  "Puzzle Sosial",
                  Icons.extension,
                  const Color(0xFFFFE082),
                  Colors.orange.shade800,
                  results,
                ),
                _buildGameItem(
                  context,
                  "Kenali Emosiku",
                  Icons.mood,
                  const Color(0xFFC1F9D2),
                  Colors.green.shade800,
                  results,
                ),
                _buildGameItem(
                  context,
                  "Keranjang Petualangan",
                  Icons.shopping_basket,
                  const Color(0xFFE1BEE7),
                  Colors.purple.shade800,
                  results,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildGameItem(
    BuildContext context,
    String gameName,
    IconData icon,
    Color bgColor,
    Color iconColor,
    Map<String, int> results,
  ) {
    final int? score = results[gameName];
    final bool isPlayed = score != null;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: bgColor,
        radius: 26,
        child: Icon(icon, color: iconColor, size: 28),
      ),
      title: Text(
        gameName,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        isPlayed ? "$score Bintang Diperoleh" : "Belum dimainkan",
        style: TextStyle(
          color: isPlayed ? Colors.green.shade600 : Colors.grey.shade500,
          fontSize: 13,
          fontWeight: isPlayed ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: () {
        if (isPlayed) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HasilGameDetailScreen(gameName: gameName, score: score),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ayo mainkan $gameName terlebih dahulu!'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}
