import 'package:flutter/material.dart';
import '../theme/color_tokens.dart';
import '../theme/app_theme.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  AppThemeExtension get themeExt =>
      Theme.of(this).extension<AppThemeExtension>()!;

  Color get background => AppColors.headerBackground;
  Color get surface => AppColors.sheetSurface;
  Color get elevated => AppColors.sheetBorder.withValues(alpha: 0.5);
  Color get borderColor => AppColors.sheetBorder;
  Color get primaryText => AppColors.sheetTextPrimary; // 0xFF0F172A Deep Navy Slate Text
  Color get secondaryText => AppColors.sheetTextSecondary; // 0xFF334155 Slate-700 High Contrast Text
  Color get accent => AppColors.darkAccent;
  Color get accentGreen => AppColors.darkAccentGreen;
  Color get accentBlue => AppColors.darkAccentBlue;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
}
