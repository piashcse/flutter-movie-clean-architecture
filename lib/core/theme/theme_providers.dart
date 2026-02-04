import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository/theme_repository.dart';
import 'repository/theme_repository_impl.dart';
import 'usecases/get_theme_mode.dart';
import 'usecases/save_theme_mode.dart';
import 'usecases/toggle_theme_mode.dart';

// Repository Provider
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepositoryImpl();
});

// Use Case Providers
final getThemeModeProvider = Provider((ref) {
  return GetThemeMode(ref.watch(themeRepositoryProvider));
});

final saveThemeModeProvider = Provider((ref) {
  return SaveThemeMode(ref.watch(themeRepositoryProvider));
});

final toggleThemeModeProvider = Provider((ref) {
  return ToggleThemeMode(ref.watch(themeRepositoryProvider));
});

// State Notifier Provider for Theme Mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref ref;

  ThemeModeNotifier(this.ref) : super(ThemeMode.system) {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    try {
      final getThemeMode = ref.read(getThemeModeProvider);
      final themeMode = await getThemeMode.call();
      state = themeMode;
    } catch (e) {
      // If initialization fails, default to system theme
      state = ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    try {
      final toggleThemeMode = ref.read(toggleThemeModeProvider);
      await toggleThemeMode.call();

      // Refresh the theme mode after toggling
      final getThemeMode = ref.read(getThemeModeProvider);
      final newThemeMode = await getThemeMode.call();
      state = newThemeMode;
    } catch (e) {
      // Handle error - maybe log it
      // print('Error toggling theme: $e'); // Commented out for production
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    try {
      final saveThemeMode = ref.read(saveThemeModeProvider);
      await saveThemeMode.call(themeMode);
      state = themeMode;
    } catch (e) {
      // Handle error - maybe log it
      // print('Error setting theme: $e'); // Commented out for production
    }
  }
}