// Core color tokens for both dark and light themes.
// All colors are designed to the exact specification in the architecture blueprint.

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Dark Mode ─────────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF161D2F);      // solid dark card surface
  static const Color darkBorder = Color(0x20FFFFFF);       // rgba(255,255,255,0.13)
  static const Color darkAccentGreen = Color(0xFF10B981);  // neon emerald
  static const Color darkAccentBlue = Color(0xFF3B82F6);   // neon blue
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkCardGlow = Color(0x2010B981);     // green glow shadow
  static const Color darkBlueGlow = Color(0x203B82F6);     // blue glow shadow
  static const Color darkDivider = Color(0x1AFFFFFF);

  // ── Light Mode ────────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF0F4F8);
  static const Color lightSurface = Color(0xFFFFFFFF);     // solid white card surface
  static const Color lightBorder = Color(0xFFE2E8F0);      // Slate 200
  static const Color lightAccentGreen = Color(0xFF059669); // flat emerald
  static const Color lightAccentBlue = Color(0xFF2563EB);  // flat blue
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569); // Slate 600 (was 64748B)
  static const Color lightDivider = Color(0x1A0F172A);

  // ── Semantic / Shared ─────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color transparent = Colors.transparent;

  // ── Student Avatar Palette ─────────────────────────────────────────────────
  static const List<Color> avatarPalette = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Violet
    Color(0xFF10B981), // Emerald
    Color(0xFF3B82F6), // Blue
    Color(0xFFF59E0B), // Amber
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFFF97316), // Orange
    Color(0xFFEF4444), // Red
    Color(0xFF06B6D4), // Cyan
    Color(0xFF84CC16), // Lime
    Color(0xFF0EA5E9), // Sky
    Color(0xFFA855F7), // Purple
    Color(0xFFD946EF), // Fuchsia
    Color(0xFFF43F5E), // Rose
    Color(0xFF64748B), // Slate/Grey
  ];
}
