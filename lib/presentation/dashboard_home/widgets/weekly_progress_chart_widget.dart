import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeeklyProgressChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> weeklyData;
  final VoidCallback onTap;

  const WeeklyProgressChartWidget({
    Key? key,
    required this.weeklyData,
    required this.onTap,
  }) : super(key: key);

  @override
  State<WeeklyProgressChartWidget> createState() =>
      _WeeklyProgressChartWidgetState();
}

class _WeeklyProgressChartWidgetState extends State<WeeklyProgressChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso semanal',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'bar_chart',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Container(
                height: 25.h,
                child: Semantics(
                  label:
                      "Gráfico de barras del progreso semanal de cigarrillos",
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: AppTheme
                              .lightTheme.primaryColor
                              .withValues(alpha: 0.9),
                          tooltipRoundedRadius: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final dayData = widget.weeklyData[group.x.toInt()];
                            return BarTooltipItem(
                              '${dayData["day"]}\n${rod.toY.round()} cigarrillos',
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ) ??
                                  const TextStyle(),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent event, barTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                barTouchResponse == null ||
                                barTouchResponse.spot == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex =
                                barTouchResponse.spot!.touchedBarGroupIndex;
                          });
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() < widget.weeklyData.length) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    widget.weeklyData[value.toInt()]["day"],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                            reservedSize: 3.h,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: _getInterval(),
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                            reservedSize: 8.w,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: _buildBarGroups(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: _getInterval(),
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              _buildWeeklySummary(),
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.weeklyData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final count = (data["count"] as num).toDouble();
      final goal = (data["goal"] as num).toDouble();

      final isOverGoal = count > goal && goal > 0;
      final isTouched = index == touchedIndex;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count,
            color: isTouched
                ? (isOverGoal
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.8)
                    : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8))
                : (isOverGoal
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.primaryColor),
            width: isTouched ? 5.w : 4.w,
            borderRadius: BorderRadius.circular(2),
            backDrawRodData: goal > 0
                ? BackgroundBarChartRodData(
                    show: true,
                    toY: goal,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  )
                : null,
          ),
        ],
      );
    }).toList();
  }

  double _getMaxY() {
    double maxCount = 0;
    double maxGoal = 0;

    for (final data in widget.weeklyData) {
      final count = (data["count"] as num).toDouble();
      final goal = (data["goal"] as num).toDouble();
      if (count > maxCount) maxCount = count;
      if (goal > maxGoal) maxGoal = goal;
    }

    final max = maxCount > maxGoal ? maxCount : maxGoal;
    return max > 0 ? (max * 1.2) : 10;
  }

  double _getInterval() {
    final maxY = _getMaxY();
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    return 20;
  }

  Widget _buildWeeklySummary() {
    final totalCount = widget.weeklyData
        .fold<int>(0, (sum, data) => sum + (data["count"] as int));
    final averageCount = widget.weeklyData.isNotEmpty
        ? (totalCount / widget.weeklyData.length)
        : 0;
    final bestDay = widget.weeklyData
        .reduce((a, b) => (a["count"] as int) < (b["count"] as int) ? a : b);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              'Total',
              '$totalCount',
              'cigarrillos',
              CustomIconWidget(
                iconName: 'smoking_rooms',
                color: AppTheme.lightTheme.primaryColor,
                size: 4.w,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 6.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _buildSummaryItem(
              'Promedio',
              '${averageCount.toStringAsFixed(1)}',
              'por día',
              CustomIconWidget(
                iconName: 'trending_flat',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 4.w,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 6.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _buildSummaryItem(
              'Mejor día',
              bestDay["day"],
              '${bestDay["count"]} cig.',
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 4.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      String title, String value, String subtitle, Widget icon) {
    return Column(
      children: [
        icon,
        SizedBox(height: 0.5.h),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}