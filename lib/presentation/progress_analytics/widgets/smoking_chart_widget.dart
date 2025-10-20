import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SmokingChartWidget extends StatefulWidget {
  final String selectedRange;

  const SmokingChartWidget({
    Key? key,
    required this.selectedRange,
  }) : super(key: key);

  @override
  State<SmokingChartWidget> createState() => _SmokingChartWidgetState();
}

class _SmokingChartWidgetState extends State<SmokingChartWidget> {
  int touchedIndex = -1;

  List<Map<String, dynamic>> get chartData {
    switch (widget.selectedRange) {
      case 'Diario':
        return [
          {'label': '00:00', 'value': 0.0},
          {'label': '04:00', 'value': 1.0},
          {'label': '08:00', 'value': 3.0},
          {'label': '12:00', 'value': 5.0},
          {'label': '16:00', 'value': 4.0},
          {'label': '20:00', 'value': 2.0},
          {'label': '24:00', 'value': 1.0},
        ];
      case 'Semanal':
        return [
          {'label': 'Lun', 'value': 12.0},
          {'label': 'Mar', 'value': 15.0},
          {'label': 'Mié', 'value': 8.0},
          {'label': 'Jue', 'value': 10.0},
          {'label': 'Vie', 'value': 18.0},
          {'label': 'Sáb', 'value': 20.0},
          {'label': 'Dom', 'value': 14.0},
        ];
      case 'Mensual':
        return [
          {'label': 'Ene', 'value': 450.0},
          {'label': 'Feb', 'value': 380.0},
          {'label': 'Mar', 'value': 320.0},
          {'label': 'Abr', 'value': 280.0},
          {'label': 'May', 'value': 240.0},
          {'label': 'Jun', 'value': 200.0},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consumo de Cigarrillos',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _getSubtitle(),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: Semantics(
              label:
                  "Gráfico de consumo de cigarrillos ${widget.selectedRange.toLowerCase()}",
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: AppTheme.lightTheme.primaryColor,
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${chartData[group.x.toInt()]['label']}\n${rod.toY.toInt()} cigarrillos',
                          AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
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
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < chartData.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Text(
                                chartData[value.toInt()]['label'],
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 4.h,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _getInterval(),
                        getTitlesWidget: (double value, TitleMeta meta) {
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
                  borderData: FlBorderData(show: false),
                  barGroups: chartData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final isTouched = index == touchedIndex;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (data['value'] as double),
                          color: isTouched
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.7),
                          width: isTouched ? 5.w : 4.w,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: _getMaxY(),
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
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
        ],
      ),
    );
  }

  String _getSubtitle() {
    switch (widget.selectedRange) {
      case 'Diario':
        return 'Hoy - 15 de octubre';
      case 'Semanal':
        return 'Esta semana - 9-15 oct';
      case 'Mensual':
        return 'Últimos 6 meses';
      default:
        return '';
    }
  }

  double _getMaxY() {
    final values = chartData.map((e) => e['value'] as double).toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue * 1.2;
  }

  double _getInterval() {
    final maxY = _getMaxY();
    if (maxY <= 10) return 2;
    if (maxY <= 50) return 10;
    if (maxY <= 200) return 50;
    return 100;
  }
}