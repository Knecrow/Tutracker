import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/haptics/haptic_service.dart';
import '../../../core/theme/color_tokens.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: context.primaryText,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  'Manage your app configurations',
                  style: TextStyle(fontSize: 13, color: context.secondaryText),
                ),
              ),

              // ── Currency Card ──────────────────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.currency_exchange_rounded,
                            size: 20, color: context.accent),
                        const SizedBox(width: 8),
                        Text(
                          'Preferred Currency',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Choose the currency symbol used across earnings trackers and graphs.',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: currencies.map((symbol) {
                        final isSelected = settings.currencySymbol == symbol;
                        return ChoiceChip(
                          label: Text(
                            symbol,
                            style: TextStyle(
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : context.primaryText,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: context.accent,
                          backgroundColor: context.borderColor.withValues(alpha: 0.15),
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected ? context.accent : context.borderColor,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              HapticService.selection();
                              settingsNotifier.setCurrencySymbol(symbol);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // ── Preferences Card ──────────────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tune_rounded,
                            size: 20, color: context.accent),
                        const SizedBox(width: 8),
                        Text(
                          'System Preferences',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Haptic Feedback',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: context.primaryText,
                        ),
                      ),
                      subtitle: Text(
                        'Enable vibration feedback on toggle items, clicks and success events.',
                        style: TextStyle(
                          fontSize: 11,
                          color: context.secondaryText,
                        ),
                      ),
                      activeColor: context.accent,
                      value: settings.hapticsEnabled,
                      onChanged: (val) {
                        HapticService.light();
                        settingsNotifier.setHapticsEnabled(val);
                      },
                    ),
                  ],
                ),
              ),

              // ── About Card ────────────────────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 20, color: context.accentBlue),
                        const SizedBox(width: 8),
                        Text(
                          'About TuTracker',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'TuTracker is a sleek, locally-saved organizer tool designed for private tutors to keep track of monthly student attendance, target classes, and pending salary amounts.',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.secondaryText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: context.borderColor),
                    const SizedBox(height: 8),
                    _AboutRow(label: 'Version', value: '1.0.0'),
                    const SizedBox(height: 6),
                    _AboutRow(label: 'Storage Type', value: 'Hive Database (Local)'),
                  ],
                ),
              ),

              // ── Danger Zone Card ──────────────────────────────────────────
              GlassCard(
                glowColor: AppColors.error.withValues(alpha: 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            size: 20, color: AppColors.error),
                        const SizedBox(width: 8),
                        Text(
                          'Danger Zone',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Resetting app data will wipe out all students, their historical billing cycles, and current attendance logs permanently.',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (dialogContext) => BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: context.themeExt.glassBlur * 1.5,
                            sigmaY: context.themeExt.glassBlur * 1.5,
                          ),
                          child: AlertDialog(
                            backgroundColor: context.isDark
                                ? const Color(0xFF131929)
                                : const Color(0xFFF0F4F8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                              side: BorderSide(color: context.borderColor),
                            ),
                            title: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    color: AppColors.error),
                                const SizedBox(width: 8),
                                Text(
                                  'Clear All Data?',
                                  style: TextStyle(
                                      color: context.primaryText,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            content: Text(
                              'Are you absolutely sure you want to purge all records? This cannot be undone.',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: context.secondaryText,
                                  height: 1.4),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text('Cancel',
                                    style:
                                        TextStyle(color: context.primaryText)),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await HapticService.heavy();
                                  Navigator.pop(dialogContext);
                                  await settingsNotifier.resetAllData();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: context.isDark
                                            ? AppColors.darkSurface
                                            : AppColors.lightSurface,
                                        content: Text(
                                          'All data wiped out.',
                                          style: TextStyle(
                                              color: context.primaryText),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Wipe Data',
                                    style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: const Text(
                        'Reset All Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: context.secondaryText)),
        Text(value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.primaryText)),
      ],
    );
  }
}
