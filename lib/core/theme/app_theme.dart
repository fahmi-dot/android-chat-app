import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_chat_app/core/constants/app_colors.dart';

class AppTheme {
  static final ThemeData _base = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    textTheme: GoogleFonts.montserratTextTheme(ThemeData().textTheme),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData get lightTheme {
    return _base.copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,

        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,

        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }

  static ThemeData get darkTheme {
    return _base.copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,

        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        error: AppColors.error,

        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );
  }
}
