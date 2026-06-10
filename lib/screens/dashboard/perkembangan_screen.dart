// lib/screens/dashboard/perkembangan_screen.dart

import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PerkembanganScreen extends StatefulWidget {
  const PerkembanganScreen({super.key});

  @override
  State<PerkembanganScreen> createState() => _PerkembanganScreenState();
}

class _PerkembanganScreenState extends State<PerkembanganScreen> {
  bool _isLoading = true;
  Map<String, int> _gameResults = {};

  // Mapping nama game ke emoji & warna
  final Map<String, Map<String, dynamic>> _gameMeta = {
    'Petualangan Rutinitasku': {
      'emoji': '🗺️',
      'color': const Color(0xFF9ED0FF),
    },
    'Puzzle Sosial': {'emoji': '🧩', 'color': const Color(0xFFFFE082)},
    'Kenali Emosiku': {'emoji': '😊', 'color': const Color(0xFFC1F9D2)},
    'Keranjang Petualangan': {'emoji': '🧺', 'color': const Color(0xFFF0C1F9)},
    'Belajar Huruf & Angka': {'emoji': '🔤', 'color': const Color(0xFFD6CCFF)},
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final results = await ApiService.getGameResults();
    if (mounted) {
      setState(() {
        _gameResults = results;
        _isLoading = false;
      });
    }
  }

  // Hitung statistik
  int get _totalSkor => _gameResults.values.fold(0, (a, b) => a + b);
  int get _totalGame => _gameResults.length;
  int get _skorTertinggi => _gameResults.isEmpty
      ? 0
      : _gameResults.values.reduce((a, b) => a > b ? a : b);
  int get _maxPossible => _totalGame * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
            )
          : RefreshIndicator(
              color: const Color(0xFF6C63FF),
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(),
                    const SizedBox(height: 28),
                    _buildSectionLabel('📊 Skor Per Game'),
                    const SizedBox(height: 14),
                    _gameResults.isEmpty
                        ? _buildEmptyState()
                        : _buildGameList(),
                    const SizedBox(height: 28),
                    if (_gameResults.isNotEmpty) ...[
                      _buildSectionLabel('🏅 Pencapaian'),
                      const SizedBox(height: 14),
                      _buildAchievements(),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────
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
        'Perkembangan',
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

  // ── Summary Cards (3 kartu statistik) ───────────────────────
  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'Game Dimainkan',
            value: '$_totalGame',
            icon: Icons.sports_esports_rounded,
            color: const Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            label: 'Total Skor',
            value: '$_totalSkor',
            icon: Icons.star_rounded,
            color: const Color(0xFFFFB347),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            label: 'Skor Tertinggi',
            value: '$_skorTertinggi',
            icon: Icons.emoji_events_rounded,
            color: const Color(0xFF4ECDC4),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ── Section Label ────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4A4A4A),
      ),
    );
  }

  // ── Game List dengan progress bar ───────────────────────────
  Widget _buildGameList() {
    final maxSkor = _gameResults.values.isEmpty
        ? 1
        : _gameResults.values.reduce((a, b) => a > b ? a : b);

    return Column(
      children: _gameResults.entries.map((entry) {
        final meta = _gameMeta[entry.key];
        final emoji = meta?['emoji'] ?? '🎮';
        final color = (meta?['color'] as Color?) ?? const Color(0xFF6C63FF);
        final pct = maxSkor == 0 ? 0.0 : entry.value / maxSkor;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Emoji icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              // Nama + progress bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: pct.toDouble(),
                        minHeight: 8,
                        backgroundColor: color.withOpacity(0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Skor
              Text(
                '${entry.value}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Empty state ──────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: const [
          Text('🎮', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text(
            'Belum ada game yang dimainkan',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Yuk mulai bermain!',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ── Pencapaian / Badge ───────────────────────────────────────
  Widget _buildAchievements() {
    final List<Map<String, dynamic>> badges = [
      {
        'label': 'Pemula',
        'desc': 'Mainkan 1 game',
        'emoji': '🌱',
        'unlocked': _totalGame >= 1,
        'color': const Color(0xFF4ECDC4),
      },
      {
        'label': 'Penjelajah',
        'desc': 'Mainkan 3 game',
        'emoji': '🗺️',
        'unlocked': _totalGame >= 3,
        'color': const Color(0xFF6C63FF),
      },
      {
        'label': 'Bintang',
        'desc': 'Total skor 200+',
        'emoji': '⭐',
        'unlocked': _totalSkor >= 200,
        'color': const Color(0xFFFFB347),
      },
      {
        'label': 'Juara',
        'desc': 'Skor tertinggi 90+',
        'emoji': '🏆',
        'unlocked': _skorTertinggi >= 90,
        'color': const Color(0xFFFF6B6B),
      },
      {
        'label': 'Master',
        'desc': 'Mainkan semua game',
        'emoji': '👑',
        'unlocked': _totalGame >= _gameMeta.length,
        'color': const Color(0xFFA18CD1),
      },
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: badges.map((badge) {
        final bool unlocked = badge['unlocked'] as bool;
        final Color color = badge['color'] as Color;

        return Container(
          width: (MediaQuery.of(context).size.width - 60) / 2,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: unlocked
                ? color.withOpacity(0.1)
                : Colors.grey.withOpacity(0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: unlocked
                  ? color.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Text(
                unlocked ? badge['emoji'] as String : '🔒',
                style: TextStyle(
                  fontSize: 28,
                  color: unlocked ? null : Colors.grey,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge['label'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: unlocked ? color : Colors.grey,
                      ),
                    ),
                    Text(
                      badge['desc'] as String,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
