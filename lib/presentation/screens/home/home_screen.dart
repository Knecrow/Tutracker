import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/attendance_provider.dart';
// removed unused imports
import '../../widgets/metric_badge.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/cycle_rollover_dialog.dart';
import '../../widgets/delete_student_dialog.dart';
import '../../widgets/attendance_row.dart';
import '../../../core/theme/theme_provider.dart';
import '../../providers/settings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final analytics = ref.watch(analyticsProvider);
    final isDark = context.isDark;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TuTracker',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: context.primaryText)),
                            const SizedBox(height: 4),
                            Text(
                              '${students.length} active student${students.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                  fontSize: 13, color: context.secondaryText),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ThemeToggleButton(
                          isDark: isDark,
                          onToggle: () =>
                              ref.read(themeProvider.notifier).toggle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingMD),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          MetricBadge(
                            label: 'PENDING',
                            value:
                                '${settings.currencySymbol}${analytics.totalPendingEarnings.toStringAsFixed(0)}',
                            icon: Icons.account_balance_wallet_outlined,
                            accent: context.accent,
                          ),
                          const SizedBox(width: 10),
                          MetricBadge(
                            label: 'CLASSES',
                            value: '${analytics.totalClassesThisMonth}',
                            icon: Icons.school_outlined,
                            accent: context.accentBlue,
                          ),
                          const SizedBox(width: 10),
                          MetricBadge(
                            label: 'STUDENTS',
                            value: '${students.length}',
                            icon: Icons.people_outline_rounded,
                            accent: isDark
                                ? AppColors.warning
                                : const Color(0xFFD97706),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Student Cards ──────────────────────────────────────────────
            students.isEmpty
                ? SliverFillRemaining(child: _EmptyState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _StudentCard(
                        studentId: students[i].id,
                      ),
                      childCount: students.length,
                    ),
                  ),

            // Bottom spacing for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ── Student Card ─────────────────────────────────────────────────────────────
class _StudentCard extends ConsumerWidget {
  const _StudentCard({required this.studentId});
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final student = students.where((s) => s.id == studentId).firstOrNull;
    if (student == null) return const SizedBox.shrink();

    final settings = ref.watch(settingsProvider);
    final attendance = ref.watch(attendanceProvider(studentId));
    final attended = attendance?.attendedCount ?? 0;
    final avatarColor = Color(student.avatarColorValue);
    final avatarTextColor = avatarColor.computeLuminance() > 0.6
        ? const Color(0xFF0F172A)
        : Colors.white;
    final perSession = student.monthlyFee / student.targetClasses;
    final earned = (perSession * attended);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMD),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        border: Border.all(color: context.borderColor),
        boxShadow: context.isDark
            ? [
                BoxShadow(
                  color: avatarColor.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Material(
          color: Colors.transparent,
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: avatarColor.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: avatarColor.withValues(alpha: 0.75), width: 1.8),
                  ),
                  child: Center(
                    child: Text(
                      student.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: avatarTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: context.primaryText,
                        ),
                      ),
                      Text(
                        '${settings.currencySymbol}${student.monthlyFee.toStringAsFixed(0)}/mo · ${student.targetClasses} classes',
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
                    Text(
                      '$attended/${student.targetClasses}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: avatarColor,
                      ),
                    ),
                    Text(
                      '${settings.currencySymbol}${earned.toStringAsFixed(0)}',
                      style:
                          TextStyle(fontSize: 10, color: context.secondaryText),
                    ),
                  ],
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    _AttendanceList(
                      studentId: studentId,
                      targetClasses: student.targetClasses,
                      accentColor: avatarColor,
                    ),
                    const SizedBox(height: 12),
                    // Action Buttons Row
                    Row(
                      children: [
                        // Delete Button
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.delete_rounded,
                                size: 18, color: AppColors.error),
                            label: Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color:
                                      AppColors.error.withValues(alpha: 0.3)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => DeleteStudentDialog(
                                studentId: studentId,
                                studentName: student.name,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Archive Cycle Button
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.refresh_rounded,
                                size: 18, color: avatarColor),
                            label: Text(
                              'Archive',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: avatarColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: avatarColor.withValues(alpha: 0.3)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => CycleRolloverDialog(
                                studentId: studentId,
                                studentName: student.name,
                                attendedCount: attended,
                                targetClasses: student.targetClasses,
                                earnedAmount: earned,
                              ),
                            ),
                          ),
                        ),
                      ],
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

// ── Attendance List ───────────────────────────────────────────────────────────
class _AttendanceList extends ConsumerWidget {
  const _AttendanceList({
    required this.studentId,
    required this.targetClasses,
    required this.accentColor,
  });
  final String studentId;
  final int targetClasses;
  final Color accentColor;

  Future<void> _selectDate(
      BuildContext context, WidgetRef ref, int index) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: context.background,
              onSurface: context.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final notifier = ref.read(attendanceProvider(studentId).notifier);
      final attendance = ref.read(attendanceProvider(studentId));
      final slotStates =
          attendance?.slotStates ?? List.filled(targetClasses, false);

      // If the slot is currently unchecked, we check it with the selected date
      // If it is ALREADY checked, we first uncheck it, then check it again with the new date
      if (slotStates[index]) {
        await notifier.toggleSlot(index); // uncheck
      }
      await notifier.toggleSlot(index,
          selectedDate: picked); // check with new date
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendance = ref.watch(attendanceProvider(studentId));
    final slotStates =
        attendance?.slotStates ?? List.filled(targetClasses, false);
    final timestamps = attendance?.timestamps ?? [];

    return Column(
      children: List.generate(targetClasses, (i) {
        final isChecked = i < slotStates.length && slotStates[i];
        final ts = timestamps.where((t) => t.endsWith('|$i')).lastOrNull;
        final iso = ts?.split('|').first;

        return AttendanceRow(
          index: i,
          isChecked: isChecked,
          timestamp: iso,
          accentColor: accentColor,
          onTapCalendar: () => _selectDate(context, ref, i),
          onToggle: () =>
              ref.read(attendanceProvider(studentId).notifier).toggleSlot(i),
        );
      }),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: context.secondaryText.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No students yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first tuition profile',
            style: TextStyle(
                fontSize: 13,
                color: context.secondaryText.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
