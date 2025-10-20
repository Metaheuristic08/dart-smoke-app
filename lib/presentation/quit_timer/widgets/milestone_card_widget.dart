import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MilestoneCardWidget extends StatelessWidget {
  final Map<String, dynamic> milestone;
  final bool isUnlocked;
  final bool isNext;

  const MilestoneCardWidget({
    Key? key,
    required this.milestone,
    required this.isUnlocked,
    required this.isNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.w,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: Card(
        elevation: isUnlocked ? 4 : 2,
        color: isUnlocked
            ? AppTheme.lightTheme.colorScheme.primaryContainer
            : isNext
                ? AppTheme.lightTheme.colorScheme.surface
                : AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isNext
              ? BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isUnlocked
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                    ),
                    child: CustomIconWidget(
                      iconName: milestone['icon'] as String,
                      color: isUnlocked
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.textSecondaryLight,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          milestone['title'] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: isUnlocked
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          milestone['timeframe'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isUnlocked)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '¡Logrado!',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                milestone['description'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isUnlocked
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textSecondaryLight,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (milestone['healthBenefit'] != null) ...[
                SizedBox(height: 1.5.h),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'favorite',
                        color: isUnlocked
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.textSecondaryLight,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          milestone['healthBenefit'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isUnlocked
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.textSecondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
