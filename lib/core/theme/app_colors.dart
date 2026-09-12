import 'package:flutter/material.dart';

class AppColors {
  // Light theme Text
  static const Color lightText = Color(0xFF111111);

  // Dark theme Text
  static const Color darkText = Color(0xFFFFFFFF);

  // Accent
  // Пока статичный цвет, но по факту буду делать его
  // акцентным, предоставляя выбор пользователю
  static const Color primary = Color(0xFF16831F);

  // Light theme
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF757575);

  // Dark theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);

  // Workout block accent colors
  static const List<Color> blockAccentColors = [
    Color(0xFF16831F),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
    Color(0xFF00ACC1),
    Color(0xFF795548),
    Color(0xFF607D8B),
    Color(0xFFF44336),
    Color(0xFF8BC34A),
  ];
}
