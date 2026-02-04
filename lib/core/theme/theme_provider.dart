import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String _themeBoxName = 'settings';
const String _themeKey = 'theme_mode';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_getSavedThemeMode());

  static ThemeMode _getSavedThemeMode() {
    try {
      final box = Hive.box(_themeBoxName);
      final savedValue = box.get(_themeKey, defaultValue: 'system');

      switch (savedValue) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
        default:
          return ThemeMode.system;
      }
    } catch (e) {
      // If there's an error retrieving the saved theme, default to system
      return ThemeMode.system;
    }
  }

  void _saveThemeMode(ThemeMode themeMode) async {
    try {
      final box = Hive.box(_themeBoxName);
      String themeValue;

      switch (themeMode) {
        case ThemeMode.light:
          themeValue = 'light';
          break;
        case ThemeMode.dark:
          themeValue = 'dark';
          break;
        case ThemeMode.system:
        default:
          themeValue = 'system';
          break;
      }

      await box.put(_themeKey, themeValue);
    } catch (e) {
      // Handle error silently or log if needed
      print('Error saving theme mode: $e');
    }
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemeMode(state);
  }

  void setLightTheme() {
    state = ThemeMode.light;
    _saveThemeMode(state);
  }

  void setDarkTheme() {
    state = ThemeMode.dark;
    _saveThemeMode(state);
  }

  void setSystemTheme() {
    state = ThemeMode.system;
    _saveThemeMode(state);
  }
}