import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/datetime_ext.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/student_provider.dart';
import '../../widgets/glass_card.dart';
import '../../providers/settings_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCycles = ref.watch(allArchivedCyclesProvider);
    final students = ref.watch(studentsProvider);
    final settings = ref.watch(settingsProvider);

    String studentName(String sid) {
      try {
        return students.firstWhere((s) => s.id == sid).name;
      } catch (_) {
        return 'Unknown';
      }
    }

    Color studentColor(String sid) {
      try {
        return Color(students.firstWhere((s) => s.id == sid).avatarColorValue);
      } catch (_) {
        return context.accent;
      }
    }

    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: context.primaryText,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'Archived billing cycles',
                style: TextStyle(fontSize: 13, color: context.secondaryText),
              ),
            ),
            Expanded(
              child: allCycles.isEmpty
                  ? _EmptyHistory()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: allCycles.length,
                      itemBuilder: (context, i) {
                        final cycle = allCycles[i];
                        final color = studentColor(cycle.studentId);
                        final start = DateTime.parse(cycle.startDate);
                        final end = cycle.endDate != null
                            ? DateTime.parse(cycle.endDate!)
                            : null;
                        final attended = cycle.archivedAttendedCount;

                        return GlassCard(
                          glowColor: color.withValues(alpha: 0.1),
                          child: Row(
                            children: [
                              // Colored left bar
                              Container(
                                width: 4,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      studentName(cycle.studentId),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: context.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${start.monthLabel}${end != null ? ' → ${end.monthLabel}' : ''}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: context.secondaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$attended classes taught',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: context.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => ref
                                        .read(
                                            allArchivedCyclesProvider.notifier)
                                        .togglePaidStatus(cycle.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: cycle.isPaid
                                            ? context.accent
                                                .withValues(alpha: 0.14)
                                            : context.borderColor
                                                .withValues(alpha: 0.25),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        border: Border.all(
                                          color: cycle.isPaid
                                              ? context.accent
                                                  .withValues(alpha: 0.35)
                                              : context.borderColor,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            cycle.isPaid
                                                ? Icons.check_circle_rounded
                                                : Icons.pending_actions_rounded,
                                            size: 14,
                                            color: cycle.isPaid
                                                ? context.accent
                                                : context.secondaryText,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            cycle.isPaid ? 'Paid' : 'Pending',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: cycle.isPaid
                                                  ? context.accent
                                                  : context.secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${settings.currencySymbol}${(cycle.totalEarned ?? 0).toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                  Text(
                                    'earned',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: context.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 64,
            color: context.secondaryText.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No history yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Closed cycles will appear here',
            style: TextStyle(
              fontSize: 12,
              color: context.secondaryText.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
