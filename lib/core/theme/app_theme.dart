import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    brightness: Brightness.light,
    fontFamily: 'Outfit',

    extensions: [AppTypography.create(AppColors.lightText)],

    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.error,
    ),

    scaffoldBackgroundColor: AppColors.lightBackground,
  );

  static ThemeData dark = ThemeData(
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    brightness: Brightness.dark,
    fontFamily: 'Outfit',

    extensions: [AppTypography.create(AppColors.darkText)],

    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.error,
    ),

    scaffoldBackgroundColor: AppColors.darkBackground,
  );
}
