import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/haptics/haptic_service.dart';
import '../../providers/student_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/cycle_rollover_dialog.dart';
import '../../widgets/delete_student_dialog.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../data/models/student.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final analytics = ref.watch(analyticsProvider);
    final settings = ref.watch(settingsProvider);
    final isDark = context.isDark;
    final accent = context.accent;

    return Scaffold(
      backgroundColor: context.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TuTracker',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: context.primaryText,
                                  letterSpacing: -0.8,
                                ),
                              ),
                              Text(
                                '${students.length} student${students.length != 1 ? 's' : ''} tracked',
                                style: TextStyle(fontSize: 13, color: context.secondaryText),
                              ),
                            ],
                          ),
                        ),
                        // Theme toggle
                        GestureDetector(
                          onTap: () => ref.read(themeProvider.notifier).toggle(),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: context.elevated,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: Icon(
                              isDark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                              size: 18,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Summary Strip ─────────────────────────────────────
                    Row(
                      children: [
                        _StatChip(
                          label: 'Pending',
                          value: '${settings.currencySymbol}${analytics.totalPendingEarnings.toStringAsFixed(0)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: accent,
                        ),
                        const SizedBox(width: 10),
                        _StatChip(
                          label: 'This month',
                          value: '${analytics.totalClassesThisMonth} classes',
                          icon: Icons.school_rounded,
                          color: context.accentGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // ── Student List ────────────────────────────────────────────────
          students.isEmpty
              ? SliverFillRemaining(child: _EmptyState())
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _StudentTile(student: students[i]),
                      childCount: students.length,
                    ),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ── Stat Chip ─────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: context.isDark ? 0.1 : 0.07),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: context.secondaryText)),
                Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Student Tile ──────────────────────────────────────────────────────────────
class _StudentTile extends ConsumerStatefulWidget {
  const _StudentTile({required this.student});
  final Student student;

  @override
  ConsumerState<_StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends ConsumerState<_StudentTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    final attendance = ref.watch(attendanceProvider(student.id));
    final settings = ref.watch(settingsProvider);

    final color = Color(student.avatarColorValue);
    final attended = attendance?.attendedCount ?? 0;
    final total = student.targetClasses;
    final progress = total > 0 ? (attended / total).clamp(0.0, 1.0) : 0.0;
    final perSession = total > 0 ? student.monthlyFee / total : 0.0;
    final earned = perSession * attended;
    final isDark = context.isDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? [BoxShadow(color: color.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))]
            : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ─────────────────────────────────────────────
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        student.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: context.primaryText,
                            )),
                        const SizedBox(height: 2),
                        Text(
                          student.subject?.isNotEmpty == true
                              ? student.subject!
                              : '${settings.currencySymbol}${student.monthlyFee.toStringAsFixed(0)}/mo',
                          style: TextStyle(fontSize: 12, color: context.secondaryText),
                        ),
                        const SizedBox(height: 8),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 5,
                            backgroundColor: context.borderColor,
                            valueColor: AlwaysStoppedAnimation(color),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Counter + chevron
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$attended/$total',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                      Text(
                        '${settings.currencySymbol}${earned.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 11, color: context.secondaryText),
                      ),
                      const SizedBox(height: 4),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(Icons.expand_more_rounded, size: 18, color: context.secondaryText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded Panel ──────────────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _expanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 1, color: context.borderColor),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: _AttendanceGrid(
                          studentId: student.id,
                          targetClasses: total,
                          accentColor: color,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                        child: _ActionRow(
                          student: student,
                          attended: attended,
                          earned: earned,
                          accentColor: color,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ── Attendance Grid (chip style) ──────────────────────────────────────────────
class _AttendanceGrid extends ConsumerWidget {
  const _AttendanceGrid({required this.studentId, required this.targetClasses, required this.accentColor});
  final String studentId;
  final int targetClasses;
  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendance = ref.watch(attendanceProvider(studentId));
    final slotStates = attendance?.slotStates ?? List.filled(targetClasses, false);
    final timestamps = attendance?.timestamps ?? [];
    final notifier = ref.read(attendanceProvider(studentId).notifier);
    final attendedCount = slotStates.where((s) => s).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attendance',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.secondaryText),
            ),
            if (attendedCount < targetClasses)
              GestureDetector(
                onTap: () => notifier.markAllAttended(targetClasses),
                child: Text(
                  'Mark all',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accentColor),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: List.generate(targetClasses, (i) {
            final isChecked = i < slotStates.length && slotStates[i];
            final ts = timestamps.where((t) => t.endsWith('|$i')).lastOrNull;
            final iso = ts?.split('|').first;
            final day = iso != null ? DateTime.tryParse(iso)?.day.toString() : null;

            return GestureDetector(
              onTap: () => notifier.toggleSlot(i),
              onLongPress: () => _pickDate(context, ref, i, slotStates),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isChecked ? accentColor : context.elevated,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: isChecked ? accentColor : context.borderColor,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: isChecked && day != null
                      ? Text(
                          day,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        )
                      : isChecked
                          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                          : Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: context.secondaryText,
                              ),
                            ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap to toggle · Long-press to pick date',
          style: TextStyle(fontSize: 10, color: context.secondaryText.withValues(alpha: 0.6)),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref, int index, List<bool> slotStates) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final notifier = ref.read(attendanceProvider(studentId).notifier);
      final currentStates = ref.read(attendanceProvider(studentId))?.slotStates ?? slotStates;
      if (index < currentStates.length && currentStates[index]) {
        await notifier.toggleSlot(index);
      }
      await notifier.toggleSlot(index, selectedDate: picked);
    }
  }
}

// ── Action Row ─────────────────────────────────────────────────────────────────
class _ActionRow extends ConsumerWidget {
  const _ActionRow({required this.student, required this.attended, required this.earned, required this.accentColor});
  final student;
  final int attended;
  final double earned;
  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _ActionBtn(
          icon: Icons.delete_outline_rounded,
          label: 'Delete',
          color: AppColors.error,
          onTap: () => showDialog(
            context: context,
            builder: (_) => DeleteStudentDialog(studentId: student.id, studentName: student.name),
          ),
        ),
        const SizedBox(width: 8),
        _ActionBtn(
          icon: Icons.edit_outlined,
          label: 'Edit',
          color: context.accentBlue,
          onTap: () => context.push('/edit-student/${student.id}'),
        ),
        const SizedBox(width: 8),
        _ActionBtn(
          icon: Icons.refresh_rounded,
          label: 'New cycle',
          color: accentColor,
          onTap: () => showDialog(
            context: context,
            builder: (_) => CycleRolloverDialog(
              studentId: student.id,
              studentName: student.name,
              attendedCount: attended,
              targetClasses: student.targetClasses,
              earnedAmount: earned,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        ),
      ),
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: context.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(Icons.person_add_rounded, size: 36, color: context.accent.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 20),
          Text('No students yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.primaryText)),
          const SizedBox(height: 6),
          Text('Tap + to add your first student',
              style: TextStyle(fontSize: 13, color: context.secondaryText)),
        ],
      ),
    );
  }
}
