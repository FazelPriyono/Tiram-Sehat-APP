import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary600,
        secondary: AppColors.primary400,
        surface: AppColors.surface,
      ),
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }

  static TextTheme get _textTheme {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 40,
        height: 48 / 40,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        height: 22 / 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.04 * 12,
        color: AppColors.textSecondary,
      ),
    );
  }
}
