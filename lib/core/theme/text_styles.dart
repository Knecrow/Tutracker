import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_tokens.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(double size, FontWeight weight, Color color) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color, letterSpacing: -0.3);

  // ── Dark ──────────────────────────────────────────────────────────────────
  static TextStyle darkDisplayLarge(BuildContext context) =>
      _base(28, FontWeight.w700, AppColors.darkTextPrimary);

  static TextStyle darkDisplayMedium(BuildContext context) =>
      _base(22, FontWeight.w600, AppColors.darkTextPrimary);

  static TextStyle darkTitle(BuildContext context) =>
      _base(18, FontWeight.w600, AppColors.darkTextPrimary);

  static TextStyle darkSubtitle(BuildContext context) =>
      _base(14, FontWeight.w500, AppColors.darkTextSecondary);

  static TextStyle darkBody(BuildContext context) =>
      _base(14, FontWeight.w400, AppColors.darkTextPrimary);

  static TextStyle darkCaption(BuildContext context) =>
      _base(11, FontWeight.w400, AppColors.darkTextSecondary);

  static TextStyle darkMetric(BuildContext context) =>
      _base(24, FontWeight.w700, AppColors.darkTextPrimary);

  static TextStyle darkAccentGreen(BuildContext context) =>
      _base(13, FontWeight.w600, AppColors.darkAccentGreen);

  // ── Light ─────────────────────────────────────────────────────────────────
  static TextStyle lightDisplayLarge(BuildContext context) =>
      _base(28, FontWeight.w700, AppColors.lightTextPrimary);

  static TextStyle lightDisplayMedium(BuildContext context) =>
      _base(22, FontWeight.w600, AppColors.lightTextPrimary);

  static TextStyle lightTitle(BuildContext context) =>
      _base(18, FontWeight.w600, AppColors.lightTextPrimary);

  static TextStyle lightSubtitle(BuildContext context) =>
      _base(14, FontWeight.w500, AppColors.lightTextSecondary);

  static TextStyle lightBody(BuildContext context) =>
      _base(14, FontWeight.w400, AppColors.lightTextPrimary);

  static TextStyle lightCaption(BuildContext context) =>
      _base(11, FontWeight.w400, AppColors.lightTextSecondary);

  static TextStyle lightMetric(BuildContext context) =>
      _base(24, FontWeight.w700, AppColors.lightTextPrimary);

  static TextStyle lightAccentGreen(BuildContext context) =>
      _base(13, FontWeight.w600, AppColors.lightAccentGreen);
}
