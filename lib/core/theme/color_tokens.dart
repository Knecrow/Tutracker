import 'package:flutter/material.dart';

/// Color tokens extracted directly from the Ocean Cyan & Sunset Orange 3D design theme.
class AppColors {
  AppColors._();

  // ── Dark Mode (Ocean Blue & Cyan) ──────────────────────────────────────────
  static const Color darkBackground   = Color(0xFF071A2E); // Deeper ocean navy
  static const Color darkSurface      = Color(0xFF0F2D48); // Elevated card surface (more contrast)
  static const Color darkElevated     = Color(0xFF1A4068); // Elevated element surface
  static const Color darkBorder       = Color(0xFF2A5F8F); // More visible ocean border
  static const Color darkAccent       = Color(0xFF00D2FF); // Electric cyan blue (Primary)
  static const Color darkAccentGreen  = Color(0xFFFF8C00); // Sunset orange (Secondary/Money)
  static const Color darkAccentBlue   = Color(0xFF38BDF8); // Bright sky blue
  static const Color darkTextPrimary  = Color(0xFFFFFFFF); // Pure white for max clarity
  static const Color darkTextSecondary= Color(0xFFAFC8DC); // Muted slate (not blue, readable)

  // ── Light Mode (High Contrast) ─────────────────────────────────────────────
  static const Color lightBackground   = Color(0xFFDEEFF8); // Slightly deeper sky tint
  static const Color lightSurface      = Color(0xFFFFFFFF); // Pure white card surface
  static const Color lightElevated     = Color(0xFFCDE4F2); // Deeper sky elevated chip
  static const Color lightBorder       = Color(0xFFABC4D8); // Visible border
  static const Color lightAccent       = Color(0xFF005F8E); // Deeper ocean for contrast
  static const Color lightAccentGreen  = Color(0xFFD9620A); // Deeper sunset orange
  static const Color lightAccentBlue   = Color(0xFF0077A8); // Deeper sky blue
  static const Color lightTextPrimary  = Color(0xFF041525); // Near-black deep navy text
  static const Color lightTextSecondary= Color(0xFF3D5A70); // Readable muted slate
  static const Color lightDivider     = Color(0xFFB8D4E8);
  static const Color darkDivider      = Color(0xFF1B3F60);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00D2FF), Color(0xFF0077B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF8C00), Color(0xFFFFB703)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success  = Color(0xFF10B981);
  static const Color warning  = Color(0xFFF59E0B);
  static const Color error    = Color(0xFFEF4444);

  // ── 7 Exact Requested Student Palette Colors ──────────────────────────────
  static const List<Color> avatarPalette = [
    Color(0xFFEF4444), // Red
    Color(0xFFF59E0B), // Yellow
    Color(0xFF84CC16), // Lime
    Color(0xFFEC4899), // Pink
    Color(0xFF8B5CF6), // Violet
    Color(0xFFA855F7), // Purple
    Color(0xFF14B8A6), // Teal
  ];
}
