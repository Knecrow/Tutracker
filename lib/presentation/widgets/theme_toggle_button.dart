import 'package:flutter/material.dart';
import '../../core/theme/color_tokens.dart';

/// Animated Sun/Moon theme toggle button.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  final bool isDark;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, anim) => RotationTransition(
            turns: Tween<double>(begin: 0.7, end: 1.0).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Icon(
            isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            key: ValueKey(isDark),
            size: 20,
            color: isDark
                ? AppColors.darkAccentGreen
                : AppColors.lightAccentGreen,
          ),
        ),
      ),
    );
  }
}
