import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _themeBoxName = 'app_settings';
const _themeModeKey = 'theme_mode';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) {
    _load();
  }

  void _load() {
    final box = Hive.box(_themeBoxName);
    final saved = box.get(_themeModeKey, defaultValue: 'dark') as String;
    state = saved == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    Hive.box(_themeBoxName).put(_themeModeKey, state == ThemeMode.dark ? 'dark' : 'light');
  }

  bool get isDark => state == ThemeMode.dark;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
