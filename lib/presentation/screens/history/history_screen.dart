import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/datetime_ext.dart';
import '../../../core/theme/color_tokens.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/settings_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycles = ref.watch(allArchivedCyclesProvider);
    final students = ref.watch(studentsProvider);
    final settings = ref.watch(settingsProvider);
    final sym = settings.currencySymbol;

    String name(String sid) {
      try {
        return students.firstWhere((s) => s.id == sid).name;
      } catch (_) {
        return 'Unknown Student';
      }
    }

    Color color(String sid) {
      try {
        return Color(students.firstWhere((s) => s.id == sid).avatarColorValue);
      } catch (_) {
        return AppColors.darkAccent;
      }
    }

    final totalPaidAmount = cycles.where((c) => c.isPaid).fold<double>(0, (sum, c) => sum + (c.totalEarned ?? 0));

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
                          'Cycle History',
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
                              label: 'Total Cycles',
                              value: '${cycles.length}',
                              icon: Icons.history_rounded,
                              color: AppColors.avatarPalette[0],
                            ),
                            const SizedBox(width: 12),
                            _HeaderStatChip(
                              label: 'Paid Total',
                              value: '$sym${totalPaidAmount.toStringAsFixed(0)}',
                              icon: Icons.check_circle_rounded,
                              color: AppColors.darkAccentGreen,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Archived Billing Cycles',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.sheetTextPrimary,
                              ),
                            ),
                            Text(
                              '${cycles.length} Recorded',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.sheetTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      cycles.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: _EmptyHistoryState(),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                              itemCount: cycles.length,
                              itemBuilder: (context, i) {
                                final cycle = cycles[i];
                                final c = color(cycle.studentId);
                                final n = name(cycle.studentId);
                                final start = DateTime.parse(cycle.startDate);
                                final end = cycle.endDate != null ? DateTime.parse(cycle.endDate!) : null;

                                return _HistoryCard(
                                  cycleId: cycle.id,
                                  name: n,
                                  color: c,
                                  startDate: start,
                                  endDate: end,
                                  attendedCount: cycle.archivedAttendedCount,
                                  totalEarned: cycle.totalEarned ?? 0,
                                  isPaid: cycle.isPaid,
                                  currencySymbol: sym,
                                );
                              },
                            ),
                    ],
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
          color: AppColors.headerSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.headerBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
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
                    style: const TextStyle(fontSize: 11, color: AppColors.headerTextSecondary, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.headerTextPrimary),
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

// ── History Tile Card (Matches HomeScreen _StudentTile Design) ───────────────
class _HistoryCard extends ConsumerWidget {
  const _HistoryCard({
    required this.cycleId,
    required this.name,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.attendedCount,
    required this.totalEarned,
    required this.isPaid,
    required this.currencySymbol,
  });

  final String cycleId;
  final String name;
  final Color color;
  final DateTime startDate;
  final DateTime? endDate;
  final int attendedCount;
  final double totalEarned;
  final bool isPaid;
  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sheetSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.sheetBorder, width: 1),
      ),
      child: Row(
        children: [
          // Circular Avatar with Status Ring
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.18),
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name & Date range
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.sheetTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  endDate != null ? '${startDate.monthLabel} → ${endDate!.monthLabel}' : startDate.monthLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.sheetTextSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '$attendedCount classes logged',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.sheetTextSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Paid badge & Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => ref.read(allArchivedCyclesProvider.notifier).togglePaidStatus(cycleId),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPaid ? AppColors.darkAccentGreen.withValues(alpha: 0.16) : AppColors.sheetBorder.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPaid ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        size: 13,
                        color: isPaid ? AppColors.darkAccentGreen : AppColors.sheetTextSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isPaid ? 'Paid' : 'Pending',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isPaid ? AppColors.darkAccentGreen : AppColors.sheetTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$currencySymbol${totalEarned.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty History State ──────────────────────────────────────────────────────
class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.sheetTextSecondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.history_rounded,
              size: 32,
              color: AppColors.sheetTextSecondary.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No archived cycles yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.sheetTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Rollover a student cycle on the home tab to archive here',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.sheetTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
