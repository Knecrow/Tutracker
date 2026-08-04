import 'package:flutter/material.dart';
import '../../core/extensions/context_ext.dart';
import '../../core/constants/app_constants.dart';

/// A pill-shaped metric badge for the home screen header.
class MetricBadge extends StatelessWidget {
  const MetricBadge({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.accent,
    this.valueStyle,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? accent;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final effectiveAccent = accent ?? context.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: effectiveAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: effectiveAccent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: effectiveAccent),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: effectiveAccent,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.primaryText,
                  letterSpacing: -0.5,
                ),
          ),
        ],
      ),
    );
  }
}
