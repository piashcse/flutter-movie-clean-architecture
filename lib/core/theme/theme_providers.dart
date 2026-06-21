import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _boxName = 'settings';
  static const _key = 'theme_mode';

  ThemeModeNotifier() : super(ThemeMode.system) {
    _init();
  }

  Future<void> _init() async {
    try {
      final box = Hive.box(_boxName);
      final saved = box.get(_key, defaultValue: 'system') as String;
      state = switch (saved) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    } catch (_) {
      state = ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    await _save(newMode);
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    await _save(themeMode);
  }

  Future<void> _save(ThemeMode themeMode) async {
    try {
      final box = Hive.box(_boxName);
      final value = switch (themeMode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await box.put(_key, value);
      state = themeMode;
    } catch (_) {}
  }
}
