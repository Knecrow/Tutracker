import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent,
        secondary: AppColors.darkAccentGreen,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        onPrimary: Colors.white,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerColor: AppColors.darkDivider,
      iconTheme: const IconThemeData(color: AppColors.darkTextSecondary, size: 20),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkTextPrimary,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 14),
        prefixIconColor: AppColors.darkTextSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.darkAccent,
        thumbColor: AppColors.darkAccent,
        inactiveTrackColor: AppColors.darkBorder,
        overlayColor: Color(0x2200D2FF),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkElevated,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: const TextStyle(color: AppColors.darkTextPrimary, fontSize: 12),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppThemeExtension(
          glassBlur: 10.0,
          accentGlow: true,
          cardGlowColor: Color(0x18A78BFA),
        ),
      ],
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        secondary: AppColors.lightAccentGreen,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        onPrimary: Colors.white,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerColor: AppColors.lightDivider,
      iconTheme: const IconThemeData(color: AppColors.lightTextSecondary, size: 20),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.lightTextPrimary,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 14),
        prefixIconColor: AppColors.lightTextSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.lightAccent,
        thumbColor: AppColors.lightAccent,
        inactiveTrackColor: AppColors.lightBorder,
        overlayColor: Color(0x220077B6),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightElevated,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: const TextStyle(color: AppColors.lightTextPrimary, fontSize: 12),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppThemeExtension(
          glassBlur: 0,
          accentGlow: false,
          cardGlowColor: Colors.transparent,
        ),
      ],
    );
  }
}

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
  AppThemeExtension copyWith({double? glassBlur, bool? accentGlow, Color? cardGlowColor}) {
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
      glassBlur: lerpDouble(glassBlur, other.glassBlur, t) ?? glassBlur,
      accentGlow: t < 0.5 ? accentGlow : other.accentGlow,
      cardGlowColor: Color.lerp(cardGlowColor, other.cardGlowColor, t)!,
    );
  }
}

double lerpDouble(double a, double b, double t) => a + (b - a) * t;
