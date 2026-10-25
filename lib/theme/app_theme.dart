import 'package:flutter/material.dart';

/// Color palette adapted from the provided reference image.
class AppColors {
  static const eggshell = Color(0xFFFCF6EF); // #FCF6EF
  static const shrek = Color(0xFFA0A742); // #A0A742
  static const babyBlue = Color(0xFFC7DBE2); // #C7DBE2
  static const matcha = Color(0xFFBBCF9B); // #BBCF9B
  static const viridian = Color(0xFF498B6D); // #498B6D
  static const sevenSeas = Color(0xFF33576E); // #33576E

  static const white = Color(0xFFFFFFFF);
  static const ink = Color(0xFF20313A);
  static const muted = Color(0xFF687780);
  static const line = Color(0xFFE3E8E8);
  static const paleGreen = Color(0xFFEAF0DF);
  static const paleBlue = Color(0xFFEAF2F5);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.eggshell,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.viridian,
          primary: AppColors.viridian,
          secondary: AppColors.shrek,
          surface: AppColors.white,
          onSurface: AppColors.ink,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.eggshell,
          foregroundColor: AppColors.ink,
          elevation: 0,
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.viridian, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.viridian,
            foregroundColor: AppColors.white,
            minimumSize: const Size.fromHeight(50),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.white,
          selectedColor: AppColors.viridian,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: const BorderSide(color: AppColors.line),
        ),
      );
}
