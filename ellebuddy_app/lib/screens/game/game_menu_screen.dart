import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/constants.dart';
import '../../widgets/game_card.dart';
import '../../screens/dashboard/login_screen.dart';
import 'kenali_emosiku_screen.dart';
import 'game_petualangan_rutinitasku.dart';
import 'puzzle_sosial_screen.dart';
import '../../main.dart';
import '../../services/streak_services.dart';

class GameMenuScreen extends StatefulWidget {
  const GameMenuScreen({super.key});

  @override
  State<GameMenuScreen> createState() => _GameMenuScreenState();
}

class _GameMenuScreenState extends State<GameMenuScreen> {
  int _currentIndex = 0;
  String _childName = "Si Kecil";
  int _streakCount = 0;
  bool _streakCompleted = false;
  bool _streakPopupShown = false;

  @override
  void initState() {
    super.initState();
    _loadChildName();
    _initStreak();
  }

  Future<void> _initStreak() async {
    await StreakService.recordOpen();
    final streak = await StreakService.getStreak();
    final completed = await StreakService.isStreakCompleted();
    setState(() {
      _streakCount = streak;
      _streakCompleted = completed;
    });

    if (completed && !_streakPopupShown) {
      _streakPopupShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showStreakPopup();
      });
    }
  }

  Future<void> _loadChildName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _childName = prefs.getString('child_name') ?? "Si Kecil";
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showStreakPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🎉", style: TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            const Text(
              "Streak 7 Hari!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "$_childName hebat! Sudah buka app 7 hari berturut-turut!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yeay! 🌟"),
          ),
        ],
      ),
    );
  }

  // ─── TAB 0: GAME ─────────────────────────────────────────────
  Widget _buildGameTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Center(child: Image.asset('images/elephant_ball.png', height: 150)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              "Ayo bermain!",
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          GameCard(
            title: "Petualangan Rutinitasku",
            imagePath: "images/game_rutinitas.png",
            backgroundColor: const Color(0xFF9ED0FF),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PetualanganRutinitaskuPage()),
            ),
          ),
          GameCard(
            title: "Puzzle Sosial",
            imagePath: "images/game_social.png",
            backgroundColor: const Color(0xFFFFE082),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PuzzleSosialPage()),
            ),
          ),
          GameCard(
            title: "Kenali Emosiku",
            imagePath: "images/game_emotion.png",
            backgroundColor: const Color(0xFFC1F9D2),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KenaliEmosikuScreen()),
            ),
          ),
          GameCard(
            title: "Keranjang Petualangan",
            imagePath: "images/game_basket.png",
            backgroundColor: const Color(0xFFF0C1F9),
            onTap: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ─── TAB 1 & 2: COMING SOON ──────────────────────────────────
  Widget _buildComingSoon(String label) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.construction, size: 60, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            "$label\nSegera hadir!",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ─── TAB 3: ACCOUNT ──────────────────────────────────────────
  Widget _buildAccountTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFE0F7F7),
            child: Icon(Icons.child_care, size: 50, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            _childName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Akun Aktif",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 32),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline, color: AppColors.primary),
            title: const Text("Profil Anak"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart, color: AppColors.primary),
            title: const Text("Perkembangan"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HELPER: item hasil game di drawer ───────────────────────
  Widget _buildHasilGameItem({
    required IconData icon,
    required String title,
    required Color color,
    required String hasil,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.black54, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      subtitle: Text(
        hasil,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  // ─── HELPER: streak widget ────────────────────────────────────
  Widget _buildStreakSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "STREAK MINGGUAN",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final isActive = i < _streakCount;
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.primary
                          : Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        ["S", "M", "S", "R", "K", "J", "S"][i],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isActive)
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                ],
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            _streakCompleted
                ? "🎉 Streak 7 hari tercapai!"
                : "$_streakCount/7 hari — terus semangat!",
            style: TextStyle(
              fontSize: 12,
              color: _streakCompleted ? AppColors.primary : Colors.grey,
              fontWeight: _streakCompleted
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      _buildGameTab(),
      _buildComingSoon("Explore"),
      _buildComingSoon("Shorts"),
      _buildAccountTab(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ─── APPBAR ──────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          "ElleBuddy",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ─── DRAWER ──────────────────────────────────────────────
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              // Header profil
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                color: AppColors.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.child_care,
                        size: 34,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _childName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Akun Aktif",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // ── Streak ──
              _buildStreakSection(),

              const Divider(),

              // ── Hasil Game ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "HASIL GAME",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              _buildHasilGameItem(
                icon: Icons.directions_run,
                title: "Petualangan Rutinitasku",
                color: const Color(0xFF9ED0FF),
                hasil: "Belum dimainkan",
              ),
              _buildHasilGameItem(
                icon: Icons.extension,
                title: "Puzzle Sosial",
                color: const Color(0xFFFFE082),
                hasil: "Belum dimainkan",
              ),
              _buildHasilGameItem(
                icon: Icons.emoji_emotions,
                title: "Kenali Emosiku",
                color: const Color(0xFFC1F9D2),
                hasil: "Belum dimainkan",
              ),
              _buildHasilGameItem(
                icon: Icons.shopping_basket,
                title: "Keranjang Petualangan",
                color: const Color(0xFFF0C1F9),
                hasil: "Belum dimainkan",
              ),

              const Spacer(),

              // ── Dark mode toggle ──
              Builder(
                builder: (context) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return SwitchListTile(
                    secondary: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: AppColors.primary,
                    ),
                    title: Text(isDark ? "Mode Gelap" : "Mode Terang"),
                    value: isDark,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      MyApp.of(context)?.toggleTheme(val);
                    },
                  );
                },
              ),

              const Divider(),

              // ── Logout ──
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: _logout,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),

      // ─── BODY ────────────────────────────────────────────────
      body: SafeArea(child: tabs[_currentIndex]),

      // ─── BOTTOM NAV ──────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.games), label: "Game"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: "Shorts",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
