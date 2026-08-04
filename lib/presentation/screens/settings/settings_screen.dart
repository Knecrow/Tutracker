import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/haptics/haptic_service.dart';
import '../../providers/settings_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final analytics = ref.watch(analyticsProvider);
    final currencies = ['৳', '\$', '€', '£', '¥', '₹', '₱'];

    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settings', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800,
                        color: context.primaryText, letterSpacing: -0.8)),
                    const SizedBox(height: 4),
                    Text('App preferences', style: TextStyle(fontSize: 13, color: context.secondaryText)),
                  ],
                ),
              ),

              // ── Currency ─────────────────────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardLabel('Currency', Icons.monetization_on_rounded, context.accent),
                    const SizedBox(height: 4),
                    Text('Symbol used across earnings displays',
                        style: TextStyle(fontSize: 12, color: context.secondaryText, height: 1.4)),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: currencies.map((sym) {
                        final sel = settings.currencySymbol == sym;
                        return GestureDetector(
                          onTap: () { HapticService.selection(); notifier.setCurrencySymbol(sym); },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: sel ? context.accent.withValues(alpha: 0.15) : context.elevated,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: sel ? context.accent : context.borderColor, width: sel ? 1.5 : 1),
                            ),
                            child: Center(
                              child: Text(sym, style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                                  color: sel ? context.accent : context.secondaryText)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // ── Preferences ──────────────────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardLabel('Preferences', Icons.tune_rounded, context.accentBlue),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Haptic Feedback',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.primaryText)),
                              Text('Vibration on interactions',
                                  style: TextStyle(fontSize: 11, color: context.secondaryText)),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: settings.hapticsEnabled,
                          activeThumbColor: context.accent,
                          activeTrackColor: context.accent.withValues(alpha: 0.3),
                          onChanged: (v) { HapticService.light(); notifier.setHapticsEnabled(v); },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── About ────────────────────────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardLabel('About TuTracker', Icons.info_outline_rounded, context.accentGreen),
                    const SizedBox(height: 12),
                    Text(
                      'A locally-saved organizer for private tutors to track monthly attendance, target classes, and salary.',
                      style: TextStyle(fontSize: 12, color: context.secondaryText, height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    Divider(color: context.borderColor),
                    const SizedBox(height: 10),
                    _Row('Version', '1.1.0', context),
                    const SizedBox(height: 8),
                    _Row('Storage', 'Hive (Local)', context),
                    const SizedBox(height: 8),
                    _Row('Lifetime Earnings',
                        '${settings.currencySymbol}${analytics.lifetimeEarnings.toStringAsFixed(0)}', context,
                        valueColor: context.accentGreen),
                  ],
                ),
              ),

              // ── Danger Zone ──────────────────────────────────────────────
              GlassCard(
                glowColor: AppColors.error.withValues(alpha: 0.08),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Danger Zone', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.error)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Permanently deletes all students, cycles, and attendance records.',
                      style: TextStyle(fontSize: 12, color: context.secondaryText, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (dc) => _ConfirmResetDialog(notifier: notifier, dialogContext: dc),
                        ),
                        child: const Text('Reset All Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Row(String label, String value, BuildContext context, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: context.secondaryText)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
            color: valueColor ?? context.primaryText)),
      ],
    );
  }
}

class _ConfirmResetDialog extends ConsumerWidget {
  const _ConfirmResetDialog({required this.notifier, required this.dialogContext});
  final SettingsNotifier notifier;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: context.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: context.borderColor)),
      title: Row(children: [
        const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
        const SizedBox(width: 8),
        Text('Clear all data?', style: TextStyle(color: context.primaryText, fontWeight: FontWeight.w700, fontSize: 16)),
      ]),
      content: Text('This cannot be undone. All students and records will be permanently deleted.',
          style: TextStyle(fontSize: 13, color: context.secondaryText, height: 1.4)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('Cancel', style: TextStyle(color: context.secondaryText)),
        ),
        TextButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final nav = Navigator.of(dialogContext);
            await HapticService.heavy();
            nav.pop();
            await notifier.resetAllData();
            messenger.showSnackBar(const SnackBar(content: Text('All data wiped.')));
          },
          child: const Text('Wipe Data', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

Widget _CardLabel(String title, IconData icon, Color color) {
  return Row(children: [
    Icon(icon, size: 16, color: color),
    const SizedBox(width: 8),
    Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
  ]);
}
