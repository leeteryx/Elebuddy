import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _lastOpenKey = 'last_open_date';
  static const String _streakKey = 'streak_count';
  static const String _streakCompletedKey = 'streak_completed';

  /// Dipanggil setiap kali app dibuka (di initState GameMenuScreen)
  static Future<void> recordOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = _dateOnly(now).toIso8601String();

    final lastOpenStr = prefs.getString(_lastOpenKey);

    if (lastOpenStr == null) {
      // Pertama kali buka
      await prefs.setString(_lastOpenKey, todayStr);
      await prefs.setInt(_streakKey, 1);
      return;
    }

    final lastOpen = DateTime.parse(lastOpenStr);
    final diff = _dateOnly(now).difference(_dateOnly(lastOpen)).inDays;

    if (diff == 0) {
      // Sudah dibuka hari ini, tidak perlu update
      return;
    } else if (diff == 1) {
      // Hari berturut-turut
      final current = prefs.getInt(_streakKey) ?? 1;
      final newStreak = current + 1;
      await prefs.setInt(_streakKey, newStreak);
      await prefs.setString(_lastOpenKey, todayStr);

      if (newStreak >= 7) {
        await prefs.setBool(_streakCompletedKey, true);
      }
    } else {
      // Streak putus, reset
      await prefs.setInt(_streakKey, 1);
      await prefs.setString(_lastOpenKey, todayStr);
      await prefs.setBool(_streakCompletedKey, false);
    }
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<bool> isStreakCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_streakCompletedKey) ?? false;
  }

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
