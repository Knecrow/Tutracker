import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/haptics/haptic_service.dart';
import '../../providers/settings_provider.dart';
import '../../providers/analytics_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final analytics = ref.watch(analyticsProvider);
    final currencies = ['৳', '\$', '€', '£', '¥', '₹', '₱'];

    return Scaffold(
      backgroundColor: AppColors.headerBackground,
      body: Stack(
        children: [
          // ── Steel Blue Header Background ──────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Container(color: AppColors.headerBackground),
          ),
          CustomScrollView(
            slivers: [
              // ── Header Area (Deep Steel Blue) ────────────────────────
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.headerTextPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Summary Cards (Steel Blue Cards) ──────────────
                        Row(
                          children: [
                            _HeaderStatChip(
                              label: 'Currency',
                              value: settings.currencySymbol,
                              icon: Icons.monetization_on_rounded,
                              color: AppColors.avatarPalette[0],
                            ),
                            const SizedBox(width: 12),
                            _HeaderStatChip(
                              label: 'Version',
                              value: 'v1.6.0',
                              icon: Icons.info_outline_rounded,
                              color: AppColors.darkAccentBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Main Content Sheet (Curved Icy Blue Sheet Container) ───
              SliverToBoxAdapter(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 240,
                  ),
                  decoration: const BoxDecoration(
                    gradient: AppColors.sheetGradient,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Currency Selection Card ───────────────────────
                        _SheetSectionCard(
                          title: 'Currency Symbol',
                          subtitle: 'Display currency',
                          icon: Icons.attach_money_rounded,
                          iconColor: AppColors.darkAccent,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: currencies.map((sym) {
                              final sel = settings.currencySymbol == sym;
                              return GestureDetector(
                                onTap: () {
                                  HapticService.selection();
                                  notifier.setCurrencySymbol(sym);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: sel ? AppColors.darkAccent.withValues(alpha: 0.18) : AppColors.sheetBorder.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: sel ? AppColors.darkAccent : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      sym,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: sel ? FontWeight.w900 : FontWeight.w600,
                                        color: sel ? AppColors.darkAccent : AppColors.sheetTextSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Preferences Card ──────────────────────────────
                        _SheetSectionCard(
                          title: 'Preferences',
                          subtitle: 'Feedback & vibration',
                          icon: Icons.tune_rounded,
                          iconColor: AppColors.darkAccentBlue,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Haptic Feedback',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.sheetTextPrimary),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Vibration on tap',
                                      style: TextStyle(fontSize: 11, color: AppColors.sheetTextSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: settings.hapticsEnabled,
                                activeThumbColor: AppColors.darkAccent,
                                activeTrackColor: AppColors.darkAccent.withValues(alpha: 0.3),
                                onChanged: (v) {
                                  HapticService.light();
                                  notifier.setHapticsEnabled(v);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                         // ── Creator & Developer Card ────────────────────────
                        _SheetSectionCard(
                          title: 'Creator & Developer',
                          subtitle: 'Crafted with ❤️',
                          icon: Icons.code_rounded,
                          iconColor: const Color(0xFF2563EB),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.getMetallicGradient(const Color(0xFFD4AF37)),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'K',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Knecrow',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.sheetTextPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Creator & Lead Developer of TuTracker',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.sheetTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              GestureDetector(
                                onTap: () async {
                                  HapticService.medium();
                                  final uri = Uri.parse('https://github.com/Knecrow');
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.code_rounded, size: 18, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                        'github.com/Knecrow',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(Icons.open_in_new_rounded, size: 15, color: Colors.white70),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── About TuTracker Card ──────────────────────────
                        _SheetSectionCard(
                          title: 'About TuTracker',
                          subtitle: '',
                          icon: Icons.auto_awesome_rounded,
                          iconColor: AppColors.darkAccentGreen,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(label: 'Version', value: '1.6.0'),
                              const SizedBox(height: 8),
                              _InfoRow(label: 'Storage', value: 'Hive (Local)'),
                              const SizedBox(height: 8),
                              _InfoRow(
                                label: 'Creator',
                                value: 'Knecrow',
                                valueColor: AppColors.sheetTextPrimary,
                              ),
                              const SizedBox(height: 8),
                              _InfoRow(
                                label: 'Lifetime Earnings',
                                value: '${settings.currencySymbol}${analytics.lifetimeEarnings.toStringAsFixed(0)}',
                                valueColor: AppColors.darkAccentGreen,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Danger Zone Card ──────────────────────────────
                        _SheetSectionCard(
                          title: 'Danger Zone',
                          subtitle: '',
                          icon: Icons.warning_amber_rounded,
                          iconColor: AppColors.error,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 46),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: 0,
                              ),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (dc) => _ConfirmResetDialog(notifier: notifier, dialogContext: dc),
                              ),
                              child: const Text(
                                'Reset All Data',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Header Stat Chip ────────────────────────────────────────────────────────
class _HeaderStatChip extends StatelessWidget {
  const _HeaderStatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.sheetSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.sheetBorder.withValues(alpha: 0.8), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sheet Section Card (Matches _StudentTile Container Aesthetic) ────────────
class _SheetSectionCard extends StatelessWidget {
  const _SheetSectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.sheetSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.sheetBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.sheetTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.sheetTextSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.sheetTextPrimary,
          ),
        ),
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
      backgroundColor: AppColors.sheetSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
          SizedBox(width: 8),
          Text(
            'Clear all data?',
            style: TextStyle(color: AppColors.sheetTextPrimary, fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ],
      ),
      content: const Text(
        'This cannot be undone. All students and records will be permanently deleted.',
        style: TextStyle(fontSize: 13, color: AppColors.sheetTextSecondary, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel', style: TextStyle(color: AppColors.sheetTextSecondary)),
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
