import 'package:flutter/material.dart';
import '../repository/theme_repository.dart';

class GetThemeMode {
  final ThemeRepository repository;

  GetThemeMode(this.repository);

  Future<ThemeMode> call() => repository.getThemeMode();
}