import 'package:flutter/material.dart';

/// Steel Blue Header & Icy Sheet Color Tokens (from user mockup)
class AppColors {
  AppColors._();

  // ── Steel Blue Header Section (Top Page Area) ──────────────────────────────
  static const Color headerBackground = Color(0xFF14243B); // Deep Steel Blue Top
  static const Color headerSurface    = Color(0xFF1E324F); // Steel Card Surface
  static const Color headerBorder     = Color(0xFF2B4468); // Soft Steel Border
  static const Color headerTextPrimary= Color(0xFFFFFFFF); // Pure White Header Text
  static const Color headerTextSecondary = Color(0xFFCBD5E1); // Slate Header Text (High Contrast)

  // ── Curved Icy Sheet Section (Bottom Main Area) ────────────────────────────
  static const Color sheetBackgroundStart = Color(0xFFEAF2F8); // Icy Blue Gradient Top
  static const Color sheetBackgroundEnd   = Color(0xFFD8E5F2); // Icy Blue Gradient Bottom
  static const Color sheetSurface         = Color(0xFFF5F9FD); // Clean List Card Surface
  static const Color sheetBorder          = Color(0xFFD2E0F0); // Delicate Sheet Border
  static const Color sheetTextPrimary     = Color(0xFF0F172A); // Deep Slate Navy Primary Text
  static const Color sheetTextSecondary   = Color(0xFF334155); // Slate-700 High Contrast Secondary Text

  // ── Global Standard Surface Colors (Backwards compatibility) ───────────────
  static const Color darkBackground   = Color(0xFF14243B);
  static const Color darkSurface      = Color(0xFF1E324F);
  static const Color darkElevated     = Color(0xFF284166);
  static const Color darkBorder       = Color(0xFF2B4468);
  static const Color darkAccent       = Color(0xFFF59E0B); // Amber Gold (Like Pay Now button)
  static const Color darkAccentGreen  = Color(0xFF10B981);
  static const Color darkAccentBlue   = Color(0xFF3B82F6);
  static const Color darkTextPrimary  = Color(0xFFFFFFFF);
  static const Color darkTextSecondary= Color(0xFF94A3B8);

  static const Color lightBackground   = Color(0xFF14243B); // Unified Steel Top
  static const Color lightSurface      = Color(0xFFF5F9FD);
  static const Color lightElevated     = Color(0xFFE2ECF7);
  static const Color lightBorder       = Color(0xFFD2E0F0);
  static const Color lightAccent       = Color(0xFFF59E0B);
  static const Color lightAccentGreen  = Color(0xFF10B981);
  static const Color lightAccentBlue   = Color(0xFF3B82F6);
  static const Color lightTextPrimary  = Color(0xFF1E293B);
  static const Color lightTextSecondary= Color(0xFF64748B);
  static const Color lightDivider     = Color(0xFFE2E8F0);
  static const Color darkDivider      = Color(0xFF2B4468);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sheetGradient = LinearGradient(
    colors: [sheetBackgroundStart, sheetBackgroundEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success  = Color(0xFF10B981);
  static const Color warning  = Color(0xFFF59E0B);
  static const Color error    = Color(0xFFEF4444);

  // ── Student Color Palette (10 Distinct High-Contrast Colors) ──────────────
  static const List<Color> avatarPalette = [
    Color(0xFF2563EB), // 1. Royal Blue
    Color(0xFF10B981), // 2. Emerald Green
    Color(0xFFF59E0B), // 3. Amber Gold
    Color(0xFF7C3AED), // 4. Violet Purple
    Color(0xFFE11D48), // 5. Crimson Rose
    Color(0xFF06B6D4), // 6. Electric Cyan
    Color(0xFFEA580C), // 7. Sunset Orange
    Color(0xFF4F46E5), // 8. Deep Indigo
    Color(0xFF65A30D), // 9. Apple Lime
    Color(0xFFC026D3), // 10. Berry Magenta
  ];
}
