import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString(
    'theme_mode',
  ); // 'light', 'dark', atau null

  runApp(MyApp(savedTheme: savedTheme));
}

class MyApp extends StatefulWidget {
  final String? savedTheme;
  const MyApp({super.key, this.savedTheme});

  // Supaya bisa dipanggil dari mana saja
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    // Kalau belum pernah set → ikut sistem HP
    if (widget.savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (widget.savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    await prefs.setString('theme_mode', isDark ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'elebuddy',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.cyan,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      themeMode: _themeMode,
      home: const SplashScreen(),
    );
  }
}
