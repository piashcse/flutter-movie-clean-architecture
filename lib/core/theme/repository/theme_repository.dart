import 'package:flutter/material.dart';

abstract class ThemeRepository {
  Future<ThemeMode> getThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<void> toggleThemeMode();
}