import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/color_tokens.dart';
import '../../providers/student_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/cycle_rollover_dialog.dart';
import '../../widgets/delete_student_dialog.dart';
import '../../../data/models/student.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final analytics = ref.watch(analyticsProvider);
    final settings = ref.watch(settingsProvider);

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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TuTracker Overview',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.headerTextPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ── Summary Cards (Steel Blue Cards) ──────────────
                        Row(
                          children: [
                            _StatChip(
                              label: 'Students',
                              value: '${students.length}',
                              icon: Icons.people_alt_rounded,
                              color: AppColors.avatarPalette[0],
                            ),
                            const SizedBox(width: 12),
                            _StatChip(
                              label: 'Pending',
                              value: '${settings.currencySymbol}${analytics.totalPendingEarnings.toStringAsFixed(0)}',
                              icon: Icons.account_balance_wallet_rounded,
                              color: AppColors.avatarPalette[1],
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
                              'Students & Attendance',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.sheetTextPrimary,
                              ),
                            ),
                            Text(
                              '${students.length} Total',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.sheetTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      students.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: _EmptyState(),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              itemCount: students.length,
                              itemBuilder: (context, i) => _StudentTile(student: students[i]),
                            ),
                      const SizedBox(height: 100),
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

// ── Stat Chip (Samsung One UI Solid Grouped Card) ───────────────────────────────
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

// ── Student Tile (Samsung One UI Solid 26px Squircle) ─────────────────────────
class _StudentTile extends ConsumerStatefulWidget {
  const _StudentTile({required this.student});
  final Student student;

  @override
  ConsumerState<_StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends ConsumerState<_StudentTile> {
  bool _expanded = false;
  bool _isPressed = false;

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

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.sheetSurface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.sheetBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
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
                          student.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Name & Subject
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
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
                            student.subject?.isNotEmpty == true
                                ? student.subject!
                                : '${settings.currencySymbol}${student.monthlyFee.toStringAsFixed(0)}/mo',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: AppColors.sheetTextSecondary),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 4,
                              backgroundColor: AppColors.sheetBorder,
                              valueColor: AlwaysStoppedAnimation(color),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // ── Vibrant Action Pill Button (Matches User Mockup 'Pay Now' Pill) ──
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$attended/$total',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            AnimatedRotation(
                              turns: _expanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
    ),
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
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sheetTextSecondary),
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
        Column(
          children: List.generate(targetClasses, (i) {
            final isChecked = i < slotStates.length && slotStates[i];
            final ts = timestamps.where((t) => t.endsWith('|$i')).lastOrNull;
            final iso = ts?.split('|').first;
            final dt = iso != null ? DateTime.tryParse(iso) : null;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isChecked
                      ? accentColor.withValues(alpha: 0.15)
                      : AppColors.sheetBorder.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isChecked ? accentColor.withValues(alpha: 0.3) : AppColors.sheetBorder.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Class label & Date
                    Text(
                      'Class ${i + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isChecked ? AppColors.sheetTextPrimary : AppColors.sheetTextSecondary,
                      ),
                    ),
                    if (isChecked && dt != null) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            DateFormat('d MMM').format(dt),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),

                    // Calendar button (pick custom date)
                    GestureDetector(
                      onTap: () => _pickDate(context, ref, i, slotStates),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.sheetSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.sheetBorder, width: 1),
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: isChecked ? accentColor : AppColors.sheetTextSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Toggle switch (Toggle ON = Today's date)
                    Switch.adaptive(
                      value: isChecked,
                      activeThumbColor: accentColor,
                      activeTrackColor: accentColor.withValues(alpha: 0.3),
                      inactiveTrackColor: Colors.grey.withValues(alpha: 0.4),
                      inactiveThumbColor: Colors.white,
                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (val) {
                        if (val) {
                          // Toggle ON -> Mark Today's date
                          notifier.toggleSlot(i, selectedDate: DateTime.now());
                        } else {
                          // Toggle OFF -> Unmark
                          notifier.toggleSlot(i);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
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
        Tooltip(
          message: 'Delete student',
          child: _ActionBtn(
            icon: Icons.delete_outline_rounded,
            color: const Color(0xFFEF4444),
            onTap: () => showDialog(
              context: context,
              builder: (_) => DeleteStudentDialog(studentId: student.id, studentName: student.name),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: 'Edit student',
          child: _ActionBtn(
            icon: Icons.edit_outlined,
            color: const Color(0xFFFF8C00),
            onTap: () => context.push('/edit-student/${student.id}'),
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: 'Start new cycle',
          child: _ActionBtn(
            icon: Icons.refresh_rounded,
            color: const Color(0xFF10B981),
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
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({required this.icon, required this.color, required this.onTap});
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 20, color: color),
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
              color: AppColors.darkAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.person_add_rounded, size: 36, color: AppColors.darkAccent),
          ),
          const SizedBox(height: 20),
          const Text(
            'No students yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.sheetTextPrimary),
          ),
        ],
      ),
    );
  }
}
