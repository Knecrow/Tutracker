import 'package:flutter/material.dart';
import '../../core/extensions/context_ext.dart';

/// Core reusable card with Samsung One UI spring touch animations.
class TCard extends StatefulWidget {
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
  State<TCard> createState() => _TCardState();
}

class _TCardState extends State<TCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(26);
    final bg = widget.color ?? context.surface;

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: Container(
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: widget.border,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => widget.onTap != null ? setState(() => _isPressed = true) : null,
            onTapUp: (_) => widget.onTap != null ? setState(() => _isPressed = false) : null,
            onTapCancel: () => widget.onTap != null ? setState(() => _isPressed = false) : null,
            borderRadius: radius,
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: widget.child,
            ),
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
    super.border,
  });
}
