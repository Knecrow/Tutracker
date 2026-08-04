import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/color_tokens.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  AppThemeExtension get themeExt =>
      Theme.of(this).extension<AppThemeExtension>()!;

  // Semantic color shortcuts
  Color get background =>
      isDark ? AppColors.darkBackground : AppColors.lightBackground;

  Color get surface =>
      isDark ? AppColors.darkSurface : AppColors.lightSurface;

  Color get borderColor =>
      isDark ? AppColors.darkBorder : AppColors.lightBorder;

  Color get primaryText =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get secondaryText =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  Color get accent =>
      isDark ? AppColors.darkAccentGreen : AppColors.lightAccentGreen;

  Color get accentBlue =>
      isDark ? AppColors.darkAccentBlue : AppColors.lightAccentBlue;

  // Screen dimensions
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
}
