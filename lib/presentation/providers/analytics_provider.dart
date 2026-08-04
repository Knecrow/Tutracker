import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../core/extensions/datetime_ext.dart';
import '../../core/theme/color_tokens.dart';
import 'student_provider.dart';
import 'attendance_provider.dart';

class AnalyticsData {
  final List<FlSpot> earningsTrend;      // last 6 months
  final List<String> trendMonthLabels;  // x-axis labels
  final List<BarChartGroupData> weeklyBars;
  final List<DonutEntry> donutEntries;
  final double totalPendingEarnings;
  final int totalClassesThisMonth;
  final double lifetimeEarnings;

  const AnalyticsData({
    required this.earningsTrend,
    required this.trendMonthLabels,
    required this.weeklyBars,
    required this.donutEntries,
    required this.totalPendingEarnings,
    required this.totalClassesThisMonth,
    required this.lifetimeEarnings,
  });

  static const AnalyticsData empty = AnalyticsData(
    earningsTrend: [],
    trendMonthLabels: [],
    weeklyBars: [],
    donutEntries: [],
    totalPendingEarnings: 0,
    totalClassesThisMonth: 0,
    lifetimeEarnings: 0,
  );
}

class DonutEntry {
  final String studentId;
  final String studentName;
  final double percent;
  final Color color;

  const DonutEntry({
    required this.studentId,
    required this.studentName,
    required this.percent,
    required this.color,
  });
}

final analyticsProvider = Provider<AnalyticsData>((ref) {
  final students = ref.watch(studentsProvider);

  final cycleRepo = CycleRepository();
  final attendanceRepo = AttendanceRepository();

  double totalPending = 0;
  int totalClassesThisMonth = 0;
  double lifetimeEarnings = 0;
  final donutEntries = <DonutEntry>[];

  final now = DateTime.now();
  final currentMonthStart = DateTime(now.year, now.month, 1);
  final currentMonthEnd = DateTime(now.year, now.month + 1, 1);

  // ── Donut + Pending Earnings ─────────────────────────────────────────────
  for (var i = 0; i < students.length; i++) {
    final s = students[i];
    // Watch attendance to get reactive updates
    final log = ref.watch(attendanceProvider(s.id));
    final attended = log?.attendedCount ?? 0;
    final percent = s.targetClasses > 0
        ? (attended / s.targetClasses * 100).clamp(0.0, 100.0)
        : 0.0;
    final perSession = s.targetClasses > 0 ? s.monthlyFee / s.targetClasses : 0.0;

    // Pending = only the current active cycle's unpaid earned amount
    totalPending += perSession * attended;

    // Classes this month = only timestamps within current calendar month
    final allDates = attendanceRepo.getAttendedDates(s.id);
    final thisMonthCount = allDates.where((d) =>
        !d.isBefore(currentMonthStart) && d.isBefore(currentMonthEnd)).length;
    totalClassesThisMonth += thisMonthCount;

    donutEntries.add(DonutEntry(
      studentId: s.id,
      studentName: s.name,
      percent: percent,
      color: Color(s.avatarColorValue),
    ));
  }

  // ── Earnings Trend (last 6 archived cycles grouped by month) ────────────
  final monthMap = <String, double>{};
  final monthLabels = <String>[];

  for (var i = 5; i >= 0; i--) {
    final d = DateTime(now.year, now.month - i, 1);
    final key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
    monthMap[key] = 0.0;
    monthLabels.add(d.monthLabel);
  }

  final allCycles = cycleRepo.getAllArchivedCycles();
  for (final cycle in allCycles) {
    final earned = cycle.totalEarned ?? 0;
    lifetimeEarnings += earned;

    final dt = DateTime.parse(cycle.startDate);
    final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
    if (monthMap.containsKey(key)) {
      monthMap[key] = (monthMap[key] ?? 0) + earned;
    }
  }

  final spotValues = monthMap.values.toList();
  final earningsTrend = List.generate(
      spotValues.length, (i) => FlSpot(i.toDouble(), spotValues[i]));

  // ── Weekly Bars (current active cycle attendance) ────────────────────────
  // Use relative week index within current month (Week 1 = days 1-7, etc.)
  final weekMap = <int, int>{};
  for (final s in students) {
    final dates = attendanceRepo.getAttendedDates(s.id);
    for (final d in dates) {
      // Only include dates within current cycle month
      if (d.year == now.year && d.month == now.month) {
        final weekIndex = ((d.day - 1) ~/ 7).clamp(0, 3); // week 0..3
        weekMap[weekIndex] = (weekMap[weekIndex] ?? 0) + 1;
      }
    }
  }

  final sortedWeekKeys = weekMap.keys.toList()..sort();
  final weeklyBars = sortedWeekKeys.asMap().entries.map((e) {
    final barIndex = e.key;       // sequential bar index 0,1,2...
    final weekIndex = e.value;    // actual week index key (0..3)
    return BarChartGroupData(
      x: barIndex,
      barRods: [
        BarChartRodData(
          toY: (weekMap[weekIndex] ?? 0).toDouble(),
          width: 18,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          gradient: const LinearGradient(
            colors: [AppColors.darkAccentBlue, AppColors.darkAccentGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ],
    );
  }).toList();

  // Store week labels for x-axis
  // We'll use weekIndex to determine label: "Wk 1", "Wk 2", etc.
  return AnalyticsData(
    earningsTrend: earningsTrend,
    trendMonthLabels: monthLabels,
    weeklyBars: weeklyBars,
    donutEntries: donutEntries,
    totalPendingEarnings: totalPending,
    totalClassesThisMonth: totalClassesThisMonth,
    lifetimeEarnings: lifetimeEarnings,
  );
});
