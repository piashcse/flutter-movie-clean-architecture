import 'package:flutter/material.dart';

class AppTheme {
  // Define consistent color palettes for both themes
  static const Color lightPrimary = Colors.deepPurple;
  static const Color lightSecondary = Colors.deepPurpleAccent;
  static const Color darkPrimary = Colors.amber;
  static const Color darkSecondary = Colors.amberAccent;

  // Consistent neutral colors for both themes
  static const Color lightSurface = Colors.white;
  static const Color darkSurface = Color(0xFF121212);
  static const Color lightBackground = Colors.white;
  static const Color darkBackground = Color(0xFF121212);
  static const Color lightOnSurface = Colors.black87;
  static const Color darkOnSurface = Colors.white;
  static const Color lightOnBackground = Colors.black87;
  static const Color darkOnBackground = Colors.white;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: lightPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: lightPrimary,
    ),
    unselectedWidgetColor: Colors.grey,
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 3.0,
          ),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightSurface,
      selectedItemColor: lightPrimary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    cardTheme: const CardThemeData(
      color: lightPrimary,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: lightOnSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: lightOnSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: lightOnSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: lightOnSurface.withOpacity(0.7),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: lightPrimary,
      brightness: Brightness.light,
    ).copyWith(
      secondary: lightSecondary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: darkPrimary,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: darkPrimary,
    ),
    unselectedWidgetColor: Colors.grey,
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black54,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 3.0,
          ),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: darkPrimary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    cardTheme: const CardThemeData(
      color: darkPrimary,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkOnSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: darkOnSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: darkOnSurface.withOpacity(0.8), // Better contrast for readability
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkPrimary,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: darkSecondary,
    ),
  );
}