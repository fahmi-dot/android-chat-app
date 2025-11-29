import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_chat_app/core/constants/app_colors.dart';

class AppTheme {
  static final ThemeData _base = ThemeData(
    useMaterial3: true,
    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      headlineLarge: GoogleFonts.montserrat(
        fontSize: AppSizes.font4XL,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: AppSizes.font3XL,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: AppSizes.font2XL,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: AppSizes.fontXL,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: AppSizes.fontL,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: GoogleFonts.montserrat(
        fontSize: AppSizes.fontM,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: AppSizes.fontL,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: AppSizes.fontM,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.montserrat(
        fontSize: AppSizes.fontS,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: GoogleFonts.montserrat(
        fontSize: AppSizes.fontM,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.montserrat(
        fontSize: AppSizes.fontS,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.montserrat(
        fontSize: AppSizes.fontXS,
        fontWeight: FontWeight.w500,
      ),
    ),
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
        surfaceContainer: AppColors.background,
        error: AppColors.error,
        errorContainer: AppColors.warning,
        tertiary: AppColors.success,

        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        onError: Colors.white,
        onErrorContainer: Colors.white,
        onTertiary: Colors.white
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }

  static ThemeData get darkTheme {
    return _base.copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,

        primary: AppColors.darkPrimary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        surfaceContainer: AppColors.darkBackground,
        error: AppColors.error,
        errorContainer: AppColors.warning,
        tertiary: AppColors.success,

        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
        onError: Colors.white,
        onErrorContainer: Colors.white,
        onTertiary: Colors.white
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );
  }
}
