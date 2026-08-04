import 'package:flutter/material.dart';
import '../../core/extensions/context_ext.dart';

/// Unique, simple, and minimal brand logo for TuTracker.
class TuTrackerLogo extends StatelessWidget {
  const TuTrackerLogo({
    super.key,
    this.size = 36,
    this.showText = true,
    this.fontSize = 22,
  });

  final double size;
  final bool showText;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final green = context.accentGreen;

    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: LinearGradient(
          colors: [accent, green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.school_rounded,
          size: size * 0.55,
          color: Colors.white,
        ),
      ),
    );

    if (!showText) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
            children: [
              TextSpan(
                text: 'Tu',
                style: TextStyle(color: accent),
              ),
              TextSpan(
                text: 'Tracker',
                style: TextStyle(color: context.primaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
