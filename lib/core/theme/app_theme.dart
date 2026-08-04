import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';

class AppTheme {
  AppTheme._();

  // ── Dark Theme ─────────────────────────────────────────────────────────────
  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.darkAccentGreen,
      secondary: AppColors.darkAccentBlue,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onPrimary: Colors.white,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      dividerColor: AppColors.darkDivider,
      iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkTextPrimary,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkAccentGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.darkAccentGreen, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
        hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkAccentGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle:
              GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.darkAccentGreen,
        thumbColor: AppColors.darkAccentGreen,
        inactiveTrackColor: AppColors.darkBorder,
        overlayColor: AppColors.darkCardGlow,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppThemeExtension(
          glassBlur: 12.0,
          accentGlow: true,
          cardGlowColor: AppColors.darkCardGlow,
        ),
      ],
    );
  }

  // ── Light Theme ────────────────────────────────────────────────────────────
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.lightAccentGreen,
      secondary: AppColors.lightAccentBlue,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      onPrimary: Colors.white,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      dividerColor: AppColors.lightDivider,
      iconTheme: const IconThemeData(color: AppColors.lightTextSecondary),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.lightTextPrimary,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightAccentGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.lightAccentGreen, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
        hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightAccentGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle:
              GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.lightAccentGreen,
        thumbColor: AppColors.lightAccentGreen,
        inactiveTrackColor: AppColors.lightBorder,
        overlayColor: Color(0x1F059669),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppThemeExtension(
          glassBlur: 6.0,
          accentGlow: false,
          cardGlowColor: Colors.transparent,
        ),
      ],
    );
  }
}

// Custom theme extension to pass glassmorphic blur and glow settings
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.glassBlur,
    required this.accentGlow,
    required this.cardGlowColor,
  });

  final double glassBlur;
  final bool accentGlow;
  final Color cardGlowColor;

  @override
  AppThemeExtension copyWith(
      {double? glassBlur, bool? accentGlow, Color? cardGlowColor}) {
    return AppThemeExtension(
      glassBlur: glassBlur ?? this.glassBlur,
      accentGlow: accentGlow ?? this.accentGlow,
      cardGlowColor: cardGlowColor ?? this.cardGlowColor,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      glassBlur: lerpDouble(glassBlur, other.glassBlur, t)!,
      accentGlow: t < 0.5 ? accentGlow : other.accentGlow,
      cardGlowColor: Color.lerp(cardGlowColor, other.cardGlowColor, t)!,
    );
  }
}

double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  return (a ?? 0) + ((b ?? 0) - (a ?? 0)) * t;
}
