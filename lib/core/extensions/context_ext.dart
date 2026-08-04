import 'package:flutter/material.dart';
import 'color_tokens.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  AppThemeExtension get themeExt =>
      Theme.of(this).extension<AppThemeExtension>()!;

  Color get background =>
      isDark ? AppColors.darkBackground : AppColors.lightBackground;
  Color get surface =>
      isDark ? AppColors.darkSurface : AppColors.lightSurface;
  Color get elevated =>
      isDark ? AppColors.darkElevated : AppColors.lightElevated;
  Color get borderColor =>
      isDark ? AppColors.darkBorder : AppColors.lightBorder;
  Color get primaryText =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  Color get secondaryText =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  Color get accent =>
      isDark ? AppColors.darkAccent : AppColors.lightAccent;
  Color get accentGreen =>
      isDark ? AppColors.darkAccentGreen : AppColors.lightAccentGreen;
  Color get accentBlue =>
      isDark ? AppColors.darkAccentBlue : AppColors.lightAccentBlue;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
}
