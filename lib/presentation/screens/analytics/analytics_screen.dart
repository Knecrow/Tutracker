import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_tokens.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/settings_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final settings = ref.watch(settingsProvider);
    final sym = settings.currencySymbol;

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
                          'YOUR TEACHING ANALYTICS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.headerTextSecondary,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Insights Overview',
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
                              label: 'Pending',
                              value: '$sym${analytics.totalPendingEarnings.toStringAsFixed(0)}',
                              icon: Icons.account_balance_wallet_rounded,
                              color: AppColors.avatarPalette[0],
                            ),
                            const SizedBox(width: 10),
                            _HeaderStatChip(
                              label: 'Lifetime',
                              value: '$sym${analytics.lifetimeEarnings.toStringAsFixed(0)}',
                              icon: Icons.trending_up_rounded,
                              color: AppColors.darkAccentGreen,
                            ),
                            const SizedBox(width: 10),
                            _HeaderStatChip(
                              label: 'This Month',
                              value: '${analytics.totalClassesThisMonth} cls',
                              icon: Icons.calendar_month_rounded,
                              color: AppColors.darkAccentBlue,
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Monthly Earnings Card ─────────────────────────
                        _SheetSectionCard(
                          title: 'Monthly Earnings Trend',
                          subtitle: 'Last 6 months',
                          icon: Icons.show_chart_rounded,
                          iconColor: AppColors.darkAccent,
                          child: SizedBox(
                            height: 160,
                            child: analytics.earningsTrend.every((s) => s.y == 0)
                                ? _emptyChart('No archived cycles yet')
                                : LineChart(_lineChart(analytics, sym)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Weekly Classes Card ────────────────────────────
                        _SheetSectionCard(
                          title: 'Weekly Classes',
                          subtitle: 'Current month distribution',
                          icon: Icons.bar_chart_rounded,
                          iconColor: AppColors.darkAccentGreen,
                          child: SizedBox(
                            height: 140,
                            child: analytics.weeklyBars.isEmpty
                                ? _emptyChart('No classes logged this month')
                                : BarChart(_barChart(analytics)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Target Progress Card ───────────────────────────
                        _SheetSectionCard(
                          title: 'Target Progress',
                          subtitle: 'Cycle completion per student',
                          icon: Icons.donut_large_rounded,
                          iconColor: AppColors.darkAccentBlue,
                          child: analytics.donutEntries.isEmpty
                              ? _emptyChart('Add students to track progress')
                              : _ProgressList(entries: analytics.donutEntries),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  LineChartData _lineChart(AnalyticsData data, String sym) {
    const accent = AppColors.darkAccent;
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.sheetBorder, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (v, _) => Text(
              '$sym${v.toInt()}',
              style: const TextStyle(fontSize: 10, color: AppColors.sheetTextSecondary, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) {
              final i = v.toInt();
              if (i < 0 || i >= data.trendMonthLabels.length) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  data.trendMonthLabels[i].split(' ').first,
                  style: const TextStyle(fontSize: 10, color: AppColors.sheetTextSecondary, fontWeight: FontWeight.w500),
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
              radius: 3.5,
              color: accent,
              strokeWidth: 2,
              strokeColor: AppColors.sheetSurface,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [accent.withValues(alpha: 0.2), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.sheetSurface,
          getTooltipItems: (spots) => spots
              .map((s) => LineTooltipItem(
                    '$sym${s.y.toStringAsFixed(0)}',
                    const TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 12),
                  ))
              .toList(),
        ),
      ),
    );
  }

  BarChartData _barChart(AnalyticsData data) {
    return BarChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.sheetBorder, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            getTitlesWidget: (v, _) => Text(
              '${v.toInt()}',
              style: const TextStyle(fontSize: 10, color: AppColors.sheetTextSecondary, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Wk ${v.toInt() + 1}',
                style: const TextStyle(fontSize: 10, color: AppColors.sheetTextSecondary, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: data.weeklyBars,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => AppColors.sheetSurface,
          getTooltipItem: (g, _, rod, __) => BarTooltipItem(
            '${rod.toY.toInt()} classes',
            const TextStyle(color: AppColors.darkAccentGreen, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.headerSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.headerBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: AppColors.headerTextSecondary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.headerTextPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sheet Section Card (Matches _StudentTile Container Aesthetic) ────────────
class _SheetSectionCard extends StatelessWidget {
  const _SheetSectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.sheetSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.sheetBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.sheetTextPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.sheetTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
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
      children: entries
          .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: e.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        e.studentName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.sheetTextPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: e.percent / 100,
                          minHeight: 6,
                          backgroundColor: AppColors.sheetBorder,
                          valueColor: AlwaysStoppedAnimation(e.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${e.percent.toStringAsFixed(0)}%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: e.color),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

Widget _emptyChart(String msg) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.bar_chart_rounded, size: 32, color: AppColors.sheetTextSecondary.withValues(alpha: 0.3)),
        const SizedBox(height: 8),
        Text(msg, style: const TextStyle(fontSize: 12, color: AppColors.sheetTextSecondary)),
      ],
    ),
  );
}
