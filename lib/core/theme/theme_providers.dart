import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/storage/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _storageKey = 'theme_mode';

  @override
  ThemeMode build() {
    final saved = ref.watch(settingsStoreProvider).read(_storageKey);
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    state = themeMode;
    await ref.read(settingsStoreProvider).write(_storageKey, themeMode.name);
  }
}
