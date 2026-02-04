import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  static const String _themeBoxName = 'settings';
  static const String _themeKey = 'theme_mode';

  @override
  Future<ThemeMode> getThemeMode() async {
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

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
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
      // print('Error saving theme mode: $e'); // Commented out for production
    }
  }

  @override
  Future<void> toggleThemeMode() async {
    final currentMode = await getThemeMode();
    ThemeMode newMode;

    switch (currentMode) {
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.light;
        break;
      case ThemeMode.system:
        // If currently system, switch to light as default
        newMode = ThemeMode.light;
        break;
    }

    await saveThemeMode(newMode);
  }
}