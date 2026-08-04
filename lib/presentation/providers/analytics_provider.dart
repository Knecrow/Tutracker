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

  const AnalyticsData({
    required this.earningsTrend,
    required this.trendMonthLabels,
    required this.weeklyBars,
    required this.donutEntries,
    required this.totalPendingEarnings,
    required this.totalClassesThisMonth,
  });

  static const AnalyticsData empty = AnalyticsData(
    earningsTrend: [],
    trendMonthLabels: [],
    weeklyBars: [],
    donutEntries: [],
    totalPendingEarnings: 0,
    totalClassesThisMonth: 0,
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
  final donutEntries = <DonutEntry>[];

  // ── Donut + Pending Earnings ───────────────────────────────────────────────
  for (var i = 0; i < students.length; i++) {
    final s = students[i];
    // Watch attendance to get reactive updates
    final log = ref.watch(attendanceProvider(s.id));
    final attended = log?.attendedCount ?? 0;
    final percent = s.targetClasses > 0
        ? (attended / s.targetClasses * 100).clamp(0.0, 100.0)
        : 0.0;
    final perSession = s.monthlyFee / s.targetClasses;
    totalPending += perSession * attended;
    totalClassesThisMonth += attended;

    donutEntries.add(DonutEntry(
      studentId: s.id,
      studentName: s.name,
      percent: percent,
      color: Color(s.avatarColorValue),
    ));
  }

  // ── Earnings Trend (last 6 archived cycles grouped by month) ───────────────
  final now = DateTime.now();
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
    final dt = DateTime.parse(cycle.startDate);
    final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
    if (monthMap.containsKey(key)) {
      monthMap[key] = (monthMap[key] ?? 0) + (cycle.totalEarned ?? 0);
    }
  }

  final spotValues = monthMap.values.toList();
  final earningsTrend = List.generate(spotValues.length, (i) => FlSpot(i.toDouble(), spotValues[i]));

  // ── Weekly Bars (current active cycle attendance) ──────────────────────────
  final weekMap = <int, int>{};
  for (final s in students) {
    final dates = attendanceRepo.getAttendedDates(s.id);
    for (final d in dates) {
      final w = d.weekNumber;
      weekMap[w] = (weekMap[w] ?? 0) + 1;
    }
  }

  final sortedWeeks = weekMap.keys.toList()..sort();
  final weeklyBars = sortedWeeks.asMap().entries.map((e) {
    return BarChartGroupData(
      x: e.key,
      barRods: [
        BarChartRodData(
          toY: weekMap[e.value]!.toDouble(),
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

  return AnalyticsData(
    earningsTrend: earningsTrend,
    trendMonthLabels: monthLabels,
    weeklyBars: weeklyBars,
    donutEntries: donutEntries,
    totalPendingEarnings: totalPending,
    totalClassesThisMonth: totalClassesThisMonth,
  );
});
