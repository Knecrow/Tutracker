import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/extensions/context_ext.dart';
// removed unused import
import '../../core/constants/app_constants.dart';

/// The core reusable glassmorphic container card.
/// In dark mode: backdrop blur + neon glow.
/// In light mode: soft drop shadow + lighter blur.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.margin,
    this.glowColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? glowColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.themeExt;
    final radius = borderRadius ?? BorderRadius.circular(AppConstants.radiusLG);
    final isDark = context.isDark;
    final effectiveGlow = glowColor ??
        (isDark ? context.themeExt.cardGlowColor : Colors.transparent);

    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMD,
            vertical: AppConstants.spacingSM,
          ),
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: isDark && ext.accentGlow
            ? [
                BoxShadow(
                  color: effectiveGlow,
                  blurRadius: 24,
                  spreadRadius: -4,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: ext.glassBlur, sigmaY: ext.glassBlur),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
                  padding ?? const EdgeInsets.all(AppConstants.cardPaddingV),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: radius,
                border: Border.all(
                  color: context.borderColor,
                  width: 1,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
