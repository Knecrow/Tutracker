import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/extensions/datetime_ext.dart';
import '../../../core/theme/color_tokens.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycles = ref.watch(allArchivedCyclesProvider);
    final students = ref.watch(studentsProvider);
    final settings = ref.watch(settingsProvider);

    String name(String sid) {
      try { return students.firstWhere((s) => s.id == sid).name; } catch (_) { return 'Unknown'; }
    }
    Color color(String sid) {
      try { return Color(students.firstWhere((s) => s.id == sid).avatarColorValue); } catch (_) { return context.accent; }
    }

    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('History', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800,
                      color: context.primaryText, letterSpacing: -0.8)),
                  const SizedBox(height: 4),
                  Text('Archived billing cycles', style: TextStyle(fontSize: 13, color: context.secondaryText)),
                ],
              ),
            ),
            Expanded(
              child: cycles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: context.secondaryText.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.history_rounded, size: 32, color: context.secondaryText.withValues(alpha: 0.4)),
                          ),
                          const SizedBox(height: 14),
                          Text('No history yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.secondaryText)),
                          const SizedBox(height: 6),
                          Text('Archive a billing cycle to see it here', style: TextStyle(fontSize: 12, color: context.secondaryText.withValues(alpha: 0.6))),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: cycles.length,
                      itemBuilder: (context, i) {
                        final cycle = cycles[i];
                        final c = color(cycle.studentId);
                        final n = name(cycle.studentId);
                        final start = DateTime.parse(cycle.startDate);
                        final end = cycle.endDate != null ? DateTime.parse(cycle.endDate!) : null;

                        return GlassCard(
                          glowColor: c.withValues(alpha: 0.08),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: c.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: c.withValues(alpha: 0.3), width: 1.5),
                                ),
                                child: Center(
                                  child: Text(
                                    n.isNotEmpty ? n[0].toUpperCase() : '?',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: c),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(n, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.primaryText)),
                                    const SizedBox(height: 2),
                                    Text(
                                      end != null ? '${start.monthLabel} → ${end.monthLabel}' : start.monthLabel,
                                      style: TextStyle(fontSize: 11, color: context.secondaryText),
                                    ),
                                    const SizedBox(height: 3),
                                    Text('${cycle.archivedAttendedCount} classes',
                                        style: TextStyle(fontSize: 11, color: context.secondaryText)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => ref.read(allArchivedCyclesProvider.notifier).togglePaidStatus(cycle.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: cycle.isPaid ? context.accentGreen.withValues(alpha: 0.12) : context.elevated,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: cycle.isPaid ? context.accentGreen.withValues(alpha: 0.3) : context.borderColor,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            cycle.isPaid ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                            size: 13,
                                            color: cycle.isPaid ? context.accentGreen : context.secondaryText,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            cycle.isPaid ? 'Paid' : 'Pending',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: cycle.isPaid ? context.accentGreen : context.secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${settings.currencySymbol}${(cycle.totalEarned ?? 0).toStringAsFixed(0)}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: c),
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
