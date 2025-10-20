import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CravingHistorySection extends StatelessWidget {
  const CravingHistorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cravingHistory = [
      {
        "id": 1,
        "intensity": 8,
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
        "duration": 12, // minutes "technique": "Ejercicio de Respiración",
        "successful": true,
        "trigger": "Estrés laboral"
      },
      {
        "id": 2,
        "intensity": 6,
        "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
        "duration": 8,
        "technique": "Caminata rápida",
        "successful": true,
        "trigger": "Después de comer"
      },
      {
        "id": 3,
        "intensity": 9,
        "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
        "duration": 15,
        "technique": "Llamada a amigo",
        "successful": false,
        "trigger": "Ansiedad social"
      },
      {
        "id": 4,
        "intensity": 5,
        "timestamp": DateTime.now().subtract(const Duration(days: 1)),
        "duration": 6,
        "technique": "Juego mental",
        "successful": true,
        "trigger": "Aburrimiento"
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'history',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Historial de Antojos',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to detailed history
                },
                child: Text(
                  'Ver todo',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Statistics summary
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.secondaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Exitosos',
                    '${(cravingHistory as List).where((c) => c["successful"] == true).length}/${cravingHistory.length}',
                    AppTheme.successLight,
                    'check_circle',
                  ),
                ),
                Container(
                  width: 1,
                  height: 6.h,
                  color: AppTheme.dividerLight,
                ),
                Expanded(
                  child: _buildStatItem(
                    'Promedio',
                    '${(cravingHistory.map((c) => c["intensity"] as int).reduce((a, b) => a + b) / cravingHistory.length).toStringAsFixed(1)}/10',
                    AppTheme.accentLight,
                    'trending_down',
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Recent history list
          Text(
            'Recientes',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),

          SizedBox(height: 1.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cravingHistory.length > 3 ? 3 : cravingHistory.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final craving = cravingHistory[index];
              return _buildHistoryItem(craving);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, Color color, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> craving) {
    final DateTime timestamp = craving["timestamp"] as DateTime;
    final bool successful = craving["successful"] as bool;
    final int intensity = craving["intensity"] as int;
    final int duration = craving["duration"] as int;
    final String technique = craving["technique"] as String;
    final String trigger = craving["trigger"] as String;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: successful
            ? AppTheme.successLight.withValues(alpha: 0.05)
            : AppTheme.errorLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: successful
              ? AppTheme.successLight.withValues(alpha: 0.2)
              : AppTheme.errorLight.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: successful ? 'check_circle' : 'cancel',
                color: successful ? AppTheme.successLight : AppTheme.errorLight,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  _formatTimestamp(timestamp),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getIntensityColor(intensity).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$intensity/10',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _getIntensityColor(intensity),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Técnica: $technique',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Disparador: $trigger',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                '${duration}min',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getIntensityColor(int intensity) {
    if (intensity <= 3) {
      return AppTheme.successLight;
    } else if (intensity <= 6) {
      return AppTheme.accentLight;
    } else {
      return AppTheme.errorLight;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Hace un momento';
    }
  }
}
