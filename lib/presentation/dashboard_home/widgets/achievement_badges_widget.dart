import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;
  final VoidCallback onViewAll;

  const AchievementBadgesWidget({
    Key? key,
    required this.achievements,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recentAchievements =
        achievements.where((a) => a["isRecent"] == true).toList();

    if (recentAchievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Logros desbloqueados!',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Celebra tu progreso',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'emoji_events',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 6.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              height: 15.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentAchievements.length > 3
                    ? 3
                    : recentAchievements.length,
                itemBuilder: (context, index) {
                  final achievement = recentAchievements[index];
                  return Container(
                    width: 25.w,
                    margin: EdgeInsets.only(right: 3.w),
                    child: _buildAchievementBadge(achievement),
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onViewAll,
                icon: CustomIconWidget(
                  iconName: 'view_list',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 4.w,
                ),
                label: const Text('Ver todos los logros'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(Map<String, dynamic> achievement) {
    return GestureDetector(
      onTap: () => _showAchievementDetails(achievement),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _getBadgeColor(achievement["category"]).withValues(alpha: 0.1),
              _getBadgeColor(achievement["category"]).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                _getBadgeColor(achievement["category"]).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: _getBadgeColor(achievement["category"]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getBadgeColor(achievement["category"])
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: achievement["icon"],
                  color: Colors.white,
                  size: 6.w,
                ),
                if (achievement["isNew"] == true)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              achievement["name"],
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: _getBadgeColor(achievement["category"]),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Text(
              achievement["level"],
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBadgeColor(String category) {
    switch (category) {
      case 'streak':
        return AppTheme.lightTheme.primaryColor;
      case 'health':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'savings':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'milestone':
        return Colors.purple;
      case 'social':
        return Colors.blue;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    // This would typically show a detailed view of the achievement
    // For now, we'll just show a simple dialog
  }
}
