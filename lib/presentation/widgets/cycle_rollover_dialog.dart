import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/extensions/context_ext.dart';
import '../../core/haptics/haptic_service.dart';
import '../../core/constants/app_constants.dart';
import '../providers/cycle_provider.dart';
import '../providers/settings_provider.dart';

class CycleRolloverDialog extends ConsumerWidget {
  const CycleRolloverDialog({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.attendedCount,
    required this.targetClasses,
    required this.earnedAmount,
  });

  final String studentId;
  final String studentName;
  final int attendedCount;
  final int targetClasses;
  final double earnedAmount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = context.accent;
    final settings = ref.watch(settingsProvider);

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 8.0,
        sigmaY: 8.0,
      ),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusXL),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.refresh_rounded, color: accent, size: 26),
              ),
              const SizedBox(height: 16),
              Text(
                'Close Billing Cycle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                studentName,
                style: TextStyle(
                  fontSize: 13,
                  color: context.secondaryText,
                ),
              ),
              const SizedBox(height: 20),
              // Summary row
              _SummaryRow(
                label: 'Classes Taught',
                value: '$attendedCount / $targetClasses',
                accent: accent,
              ),
              const SizedBox(height: 8),
              _SummaryRow(
                label: 'Amount Earned',
                value: '${settings.currencySymbol}${earnedAmount.toStringAsFixed(0)}',
                accent: accent,
              ),
              const SizedBox(height: 24),
              Text(
                'This will archive the current cycle and reset the attendance grid for the next month.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: context.secondaryText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: context.elevated,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: context.secondaryText),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await HapticService.heavy();
                        await ref.read(cycleProvider(studentId).notifier).rollover(ref);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                        ),
                      ),
                      child: const Text(
                        'New Cycle',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, required this.accent});
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13, color: context.secondaryText)),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: context.primaryText)),
      ],
    );
  }
}
