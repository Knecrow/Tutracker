import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/color_tokens.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final settings = ref.watch(settingsProvider);
    final sym = settings.currencySymbol;
    final accent = context.accent;
    final green = context.accentGreen;

    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Insights',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800,
                            color: context.primaryText, letterSpacing: -0.8)),
                    const SizedBox(height: 4),
                    Text('Your teaching analytics', style: TextStyle(fontSize: 13, color: context.secondaryText)),
                    const SizedBox(height: 20),
                    // Big numbers row
                    Row(
                      children: [
                        _BigStat(label: 'Pending', value: '$sym${analytics.totalPendingEarnings.toStringAsFixed(0)}', color: accent),
                        const SizedBox(width: 12),
                        _BigStat(label: 'Lifetime', value: '$sym${analytics.lifetimeEarnings.toStringAsFixed(0)}', color: green),
                        const SizedBox(width: 12),
                        _BigStat(label: 'This month', value: '${analytics.totalClassesThisMonth}', color: context.accentBlue, suffix: 'classes'),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Earnings Trend ───────────────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel('Monthly Earnings', Icons.trending_up_rounded, accent),
                    const SizedBox(height: 4),
                    Text('Last 6 months', style: TextStyle(fontSize: 11, color: context.secondaryText)),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 160,
                      child: analytics.earningsTrend.every((s) => s.y == 0)
                          ? _EmptyChart('No archived cycles yet')
                          : LineChart(_lineChart(context, analytics, sym)),
                    ),
                  ],
                ),
              ),

              // ── Weekly Bars ──────────────────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel('Weekly Classes', Icons.bar_chart_rounded, green),
                    const SizedBox(height: 4),
                    Text('Current month', style: TextStyle(fontSize: 11, color: context.secondaryText)),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 140,
                      child: analytics.weeklyBars.isEmpty
                          ? _EmptyChart('No classes logged this month')
                          : BarChart(_barChart(context, analytics)),
                    ),
                  ],
                ),
              ),

              // ── Progress Rings ───────────────────────────────────────────
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel('Target Progress', Icons.donut_large_rounded, context.accentBlue),
                    const SizedBox(height: 4),
                    Text('Cycle completion per student', style: TextStyle(fontSize: 11, color: context.secondaryText)),
                    const SizedBox(height: 16),
                    analytics.donutEntries.isEmpty
                        ? _EmptyChart('Add students to track progress')
                        : _ProgressList(entries: analytics.donutEntries),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _lineChart(BuildContext context, AnalyticsData data, String sym) {
    final accent = context.accent;
    return LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: context.borderColor, strokeWidth: 1)),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40,
            getTitlesWidget: (v, _) => Text('$sym${v.toInt()}', style: TextStyle(fontSize: 9, color: context.secondaryText)))),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
            getTitlesWidget: (v, _) {
              final i = v.toInt();
              if (i < 0 || i >= data.trendMonthLabels.length) return const SizedBox.shrink();
              return Padding(padding: const EdgeInsets.only(top: 4),
                  child: Text(data.trendMonthLabels[i].split(' ').first,
                      style: TextStyle(fontSize: 9, color: context.secondaryText)));
            })),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: data.earningsTrend,
          isCurved: true,
          color: accent,
          barWidth: 2.5,
          dotData: FlDotData(show: true,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 3.5, color: accent,
                  strokeWidth: 2, strokeColor: context.background)),
          belowBarData: BarAreaData(show: true,
              gradient: LinearGradient(colors: [accent.withValues(alpha: 0.2), Colors.transparent],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => context.surface,
          getTooltipItems: (spots) => spots.map((s) =>
              LineTooltipItem('$sym${s.y.toStringAsFixed(0)}',
                  TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 12))).toList(),
        ),
      ),
    );
  }

  BarChartData _barChart(BuildContext context, AnalyticsData data) {
    return BarChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: context.borderColor, strokeWidth: 1)),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24,
            getTitlesWidget: (v, _) => Text('${v.toInt()}', style: TextStyle(fontSize: 9, color: context.secondaryText)))),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
            getTitlesWidget: (v, _) => Padding(padding: const EdgeInsets.only(top: 4),
                child: Text('Wk ${v.toInt() + 1}', style: TextStyle(fontSize: 9, color: context.secondaryText))))),
      ),
      borderData: FlBorderData(show: false),
      barGroups: data.weeklyBars,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => context.surface,
          getTooltipItem: (g, _, rod, __) => BarTooltipItem('${rod.toY.toInt()} classes',
              TextStyle(color: context.accentGreen, fontWeight: FontWeight.w600, fontSize: 12)),
        ),
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  const _BigStat({required this.label, required this.value, required this.color, this.suffix});
  final String label;
  final String value;
  final Color color;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: context.secondaryText)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
            if (suffix != null)
              Text(suffix!, style: TextStyle(fontSize: 9, color: context.secondaryText)),
          ],
        ),
      ),
    );
  }
}

class _ProgressList extends StatelessWidget {
  const _ProgressList({required this.entries});
  final List<DonutEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: e.color, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Expanded(child: Text(e.studentName, style: TextStyle(fontSize: 13, color: context.primaryText))),
            const SizedBox(width: 10),
            SizedBox(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: e.percent / 100,
                  minHeight: 6,
                  backgroundColor: context.borderColor,
                  valueColor: AlwaysStoppedAnimation(e.color),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('${e.percent.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: e.color)),
          ],
        ),
      )).toList(),
    );
  }
}

Widget _SectionLabel(String title, IconData icon, Color color) {
  return Row(children: [
    Icon(icon, size: 16, color: color),
    const SizedBox(width: 8),
    Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
  ]);
}

Widget _EmptyChart(String msg) {
  return Builder(builder: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.bar_chart_rounded, size: 32, color: context.secondaryText.withValues(alpha: 0.3)),
        const SizedBox(height: 8),
        Text(msg, style: TextStyle(fontSize: 12, color: context.secondaryText)),
      ],
    ),
  ));
}
