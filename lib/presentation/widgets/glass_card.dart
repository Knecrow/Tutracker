import 'package:flutter/material.dart';
import '../../core/extensions/context_ext.dart';

/// Core reusable card. Clean, minimal, no backdrop blur in light mode.
class TCard extends StatelessWidget {
  const TCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.glowColor,
    this.borderRadius,
    this.onTap,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? glowColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20);
    final isDark = context.isDark;
    final bg = color ?? context.surface;
    final glow = glowColor;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: border ?? Border.all(color: context.borderColor, width: 1),
        boxShadow: isDark && glow != null
            ? [BoxShadow(color: glow, blurRadius: 20, spreadRadius: -4, offset: const Offset(0, 6))]
            : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Keep GlassCard as alias so existing code compiles
class GlassCard extends TCard {
  const GlassCard({
    super.key,
    required super.child,
    super.padding,
    super.margin,
    super.color,
    super.glowColor,
    super.borderRadius,
    super.onTap,
  });
}
