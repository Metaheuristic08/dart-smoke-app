import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimerDisplayWidget extends StatelessWidget {
  final Duration quitDuration;
  final double progress;

  const TimerDisplayWidget({
    Key? key,
    required this.quitDuration,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: 80.w,
            height: 80.w,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8.0,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          // Timer Content
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Libre de humo',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildTimeDisplay(),
                SizedBox(height: 1.h),
                Text(
                  _getTimeLabel(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final days = quitDuration.inDays;
    final hours = quitDuration.inHours % 24;
    final minutes = quitDuration.inMinutes % 60;
    final seconds = quitDuration.inSeconds % 60;

    if (days > 0) {
      return Column(
        children: [
          Text(
            '$days',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          Text(
            days == 1 ? 'día' : 'días',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          if (hours > 0) ...[
            SizedBox(height: 0.5.h),
            Text(
              '${hours}h ${minutes}m',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ],
      );
    } else if (hours > 0) {
      return Column(
        children: [
          Text(
            '$hours:${minutes.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          Text(
            'horas:minutos',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          Text(
            'minutos:segundos',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      );
    }
  }

  String _getTimeLabel() {
    final days = quitDuration.inDays;
    final hours = quitDuration.inHours;
    final minutes = quitDuration.inMinutes;

    if (days > 0) {
      return 'desde tu último cigarrillo';
    } else if (hours > 0) {
      return 'sin fumar';
    } else if (minutes > 0) {
      return 'mantente fuerte';
    } else {
      return '¡Cada segundo cuenta!';
    }
  }
}
