import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/color_tokens.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/glass_card.dart';
import '../../providers/settings_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final settings = ref.watch(settingsProvider);

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
                  'Insights',
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
                  'Your teaching performance at a glance',
                  style: TextStyle(fontSize: 13, color: context.secondaryText),
                ),
              ),

              // ── Summary Badges ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  children: [
                    _SummaryBadge(
                      label: 'Pending',
                      value: '${settings.currencySymbol}${analytics.totalPendingEarnings.toStringAsFixed(0)}',
                      color: context.accent,
                    ),
                    const SizedBox(width: 12),
                    _SummaryBadge(
                      label: 'Lifetime',
                      value: '${settings.currencySymbol}${analytics.lifetimeEarnings.toStringAsFixed(0)}',
                      color: context.accentBlue,
                    ),
                  ],
                ),
              ),

              // ── Area Chart: Monthly Earnings ─────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ChartTitle(
                      title: 'Monthly Earnings',
                      subtitle: 'Last 6 months (archived cycles)',
                      icon: Icons.trending_up_rounded,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      child: analytics.earningsTrend.isEmpty ||
                              analytics.earningsTrend
                                  .every((s) => s.y == 0)
                          ? const _EmptyChart('No archived cycles yet')
                          : LineChart(_buildAreaChart(
                              context, analytics, settings.currencySymbol)),
                    ),
                  ],
                ),
              ),

              // ── Bar Chart: Weekly Workload ────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ChartTitle(
                      title: 'Weekly Workload',
                      subtitle: 'Classes taught this month',
                      icon: Icons.bar_chart_rounded,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 160,
                      child: analytics.weeklyBars.isEmpty
                          ? const _EmptyChart('No classes logged this month')
                          : BarChart(_buildBarChart(context, analytics)),
                    ),
                  ],
                ),
              ),

              // ── Donut Rings: Target Completion ───────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ChartTitle(
                      title: 'Target Completion',
                      subtitle: 'Progress per student this cycle',
                      icon: Icons.donut_large_rounded,
                    ),
                    const SizedBox(height: 20),
                    analytics.donutEntries.isEmpty
                        ? const _EmptyChart('Add students to see progress')
                        : _DonutRings(entries: analytics.donutEntries),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _buildAreaChart(
      BuildContext context, AnalyticsData data, String currencySymbol) {
    final accent = context.accent;
    final isDark = context.isDark;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
          color: context.borderColor,
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            getTitlesWidget: (val, _) => Text(
              '$currencySymbol${val.toInt()}',
              style: TextStyle(fontSize: 9, color: context.secondaryText),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (val, _) {
              final i = val.toInt();
              if (i < 0 || i >= data.trendMonthLabels.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  data.trendMonthLabels[i].split(' ').first,
                  style:
                      TextStyle(fontSize: 9, color: context.secondaryText),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: data.earningsTrend,
          isCurved: true,
          color: accent,
          barWidth: 2.5,
          dotData: FlDotData(
            show: true,
            getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
              radius: 4,
              color: accent,
              strokeWidth: 2,
              strokeColor:
                  isDark ? AppColors.darkBackground : Colors.white,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: isDark ? 0.3 : 0.15),
                accent.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) =>
              context.isDark ? AppColors.darkSurface : Colors.white,
          getTooltipItems: (spots) => spots
              .map((s) => LineTooltipItem(
                    '$currencySymbol${s.y.toStringAsFixed(0)}',
                    TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  BarChartData _buildBarChart(BuildContext context, AnalyticsData data) {
    return BarChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
          color: context.borderColor,
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (val, _) => Text(
              '${val.toInt()}',
              style: TextStyle(fontSize: 9, color: context.secondaryText),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (val, _) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Week ${val.toInt() + 1}',
                style:
                    TextStyle(fontSize: 9, color: context.secondaryText),
              ),
            ),
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: data.weeklyBars,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) =>
              context.isDark ? AppColors.darkSurface : Colors.white,
          getTooltipItem: (group, _, rod, __) => BarTooltipItem(
            '${rod.toY.toInt()} classes',
            TextStyle(
              color: context.accent,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Summary Badge ─────────────────────────────────────────────────────────────
class _SummaryBadge extends StatelessWidget {
  const _SummaryBadge(
      {required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: context.secondaryText),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Donut Rings ───────────────────────────────────────────────────────────────
class _DonutRings extends StatelessWidget {
  const _DonutRings({required this.entries});
  final List<DonutEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: entries.asMap().entries.map((e) {
              final idx = e.key;
              final entry = e.value;
              final radius = 80.0 - idx * 18;
              if (radius < 10) return const SizedBox.shrink();
              return PieChart(
                PieChartData(
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      value: entry.percent,
                      color: entry.color,
                      radius: 10,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 100 - entry.percent,
                      color: entry.color.withValues(alpha: 0.1),
                      radius: 10,
                      showTitle: false,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        ...entries.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: e.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    e.studentName,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.primaryText,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: e.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${e.percent.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: e.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _ChartTitle extends StatelessWidget {
  const _ChartTitle(
      {required this.title, required this.subtitle, required this.icon});
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.accent),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.primaryText)),
            Text(subtitle,
                style: TextStyle(fontSize: 11, color: context.secondaryText)),
          ],
        ),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart(this.message);
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded,
                size: 36,
                color: context.secondaryText.withValues(alpha: 0.3)),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 12, color: context.secondaryText),
            ),
          ],
        ),
      );
}
