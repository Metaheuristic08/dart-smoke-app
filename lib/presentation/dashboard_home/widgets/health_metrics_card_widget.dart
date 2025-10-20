import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthMetricsCardWidget extends StatelessWidget {
  final double moneySaved;
  final int timeRegained; // in minutes
  final List<String> healthBenefits;
  final VoidCallback onTap;

  const HealthMetricsCardWidget({
    Key? key,
    required this.moneySaved,
    required this.timeRegained,
    required this.healthBenefits,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    'Mejoras en tu salud',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 6.w,
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricItem(
                      icon: 'euro',
                      value: '€${moneySaved.toStringAsFixed(2)}',
                      label: 'Dinero ahorrado',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildMetricItem(
                      icon: 'schedule',
                      value: _formatTime(timeRegained),
                      label: 'Tiempo recuperado',
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'favorite',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Beneficios para la salud',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    ...healthBenefits
                        .take(2)
                        .map((benefit) => Padding(
                              padding: EdgeInsets.only(bottom: 0.5.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 1.h, right: 2.w),
                                    width: 1.w,
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.tertiary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      benefit,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    if (healthBenefits.length > 2) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        '+${healthBenefits.length - 2} beneficios más',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          AnimatedDigitWidget(
            value: moneySaved,
            textStyle: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ) ??
                const TextStyle(),
            fractionDigits: icon == 'euro' ? 2 : 0,
            enableSeparator: true,
            prefix: icon == 'euro' ? '€' : '',
            suffix: icon == 'schedule' ? _getTimeSuffix(timeRegained) : '',
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  String _formatTime(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0
          ? '${hours}h ${remainingMinutes}m'
          : '${hours}h';
    } else {
      final days = minutes ~/ 1440;
      final remainingHours = (minutes % 1440) ~/ 60;
      return remainingHours > 0 ? '${days}d ${remainingHours}h' : '${days}d';
    }
  }

  String _getTimeSuffix(int minutes) {
    if (minutes < 60) {
      return ' min';
    } else if (minutes < 1440) {
      return minutes % 60 > 0 ? '' : 'h';
    } else {
      return (minutes % 1440) ~/ 60 > 0 ? '' : 'd';
    }
  }
}
