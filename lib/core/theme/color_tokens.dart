import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Dark Mode ──────────────────────────────────────────────────────────────
  static const Color darkBackground  = Color(0xFF0C0E1A); // deep navy-black
  static const Color darkSurface     = Color(0xFF141727); // card surface
  static const Color darkElevated    = Color(0xFF1C2038); // elevated elements
  static const Color darkBorder      = Color(0xFF252B45); // subtle border
  static const Color darkAccent      = Color(0xFFA78BFA); // soft violet (primary)
  static const Color darkAccentGreen = Color(0xFF34D399); // emerald (money)
  static const Color darkAccentBlue  = Color(0xFF60A5FA); // blue (info)
  static const Color darkTextPrimary   = Color(0xFFEEF2FF); // warm white
  static const Color darkTextSecondary = Color(0xFF6B7A99); // muted

  // ── Light Mode ─────────────────────────────────────────────────────────────
  static const Color lightBackground  = Color(0xFFF4F6FF); // lavender-tinted white
  static const Color lightSurface     = Color(0xFFFFFFFF); // pure white card
  static const Color lightElevated    = Color(0xFFEEF0FF);
  static const Color lightBorder      = Color(0xFFDDE1F5); // soft indigo border
  static const Color lightAccent      = Color(0xFF7C3AED); // vivid violet
  static const Color lightAccentGreen = Color(0xFF059669); // emerald
  static const Color lightAccentBlue  = Color(0xFF2563EB); // blue
  static const Color lightTextPrimary   = Color(0xFF1A1F3C); // deep navy text
  static const Color lightTextSecondary = Color(0xFF7580A0);
  static const Color lightDivider = Color(0xFFE5E8F8);
  static const Color darkDivider  = Color(0xFF1E2540);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success  = Color(0xFF34D399);
  static const Color warning  = Color(0xFFFBBF24);
  static const Color error    = Color(0xFFF87171);

  // ── Avatar Palette ─────────────────────────────────────────────────────────
  static const List<Color> avatarPalette = [
    Color(0xFFA78BFA), // Violet
    Color(0xFF34D399), // Emerald
    Color(0xFF60A5FA), // Blue
    Color(0xFFFBBF24), // Amber
    Color(0xFFF472B6), // Pink
    Color(0xFF2DD4BF), // Teal
    Color(0xFFFB923C), // Orange
    Color(0xFF818CF8), // Indigo
    Color(0xFF4ADE80), // Green
    Color(0xFFE879F9), // Fuchsia
    Color(0xFF38BDF8), // Sky
    Color(0xFFF87171), // Red
    Color(0xFF84CC16), // Lime
    Color(0xFF94A3B8), // Slate
    Color(0xFFD946EF), // Magenta
    Color(0xFFA3E635), // Yellow-Green
  ];
}
