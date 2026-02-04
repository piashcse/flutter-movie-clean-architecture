import 'package:flutter/material.dart';
import '../repository/theme_repository.dart';

class SaveThemeMode {
  final ThemeRepository repository;

  SaveThemeMode(this.repository);

  Future<void> call(ThemeMode themeMode) => repository.saveThemeMode(themeMode);
}