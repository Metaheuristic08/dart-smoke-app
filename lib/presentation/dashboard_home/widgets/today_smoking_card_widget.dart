import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodaySmokingCardWidget extends StatelessWidget {
  final int todayCount;
  final int dailyGoal;
  final VoidCallback onAddCigarette;
  final Function(int) onEditEntry;
  final Function(int) onDeleteEntry;
  final Function(int) onAddNote;

  const TodaySmokingCardWidget({
    Key? key,
    required this.todayCount,
    required this.dailyGoal,
    required this.onAddCigarette,
    required this.onEditEntry,
    required this.onDeleteEntry,
    required this.onAddNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress =
        dailyGoal > 0 ? (todayCount / dailyGoal).clamp(0.0, 1.0) : 0.0;
    final isOverGoal = todayCount > dailyGoal && dailyGoal > 0;

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
                        'Cigarrillos de hoy',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        dailyGoal > 0
                            ? '$todayCount de $dailyGoal meta'
                            : '$todayCount fumados',
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
                GestureDetector(
                  onTap: onAddCigarette,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'add',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$todayCount',
                        style: AppTheme.lightTheme.textTheme.displayMedium
                            ?.copyWith(
                          color: isOverGoal
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'cigarrillos',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 6,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isOverGoal
                                  ? AppTheme.lightTheme.colorScheme.error
                                  : AppTheme.lightTheme.primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isOverGoal
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (todayCount > 0) ...[
              SizedBox(height: 2.h),
              _buildSmokingEntries(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSmokingEntries(BuildContext context) {
    return Container(
      height: 8.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: todayCount,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: Dismissible(
              key: Key('smoking_entry_$index'),
              direction: DismissDirection.startToEnd,
              background: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 4.w,
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) => onDeleteEntry(index),
              child: GestureDetector(
                onTap: () => _showEntryOptions(context, index),
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'smoking_rooms',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEntryOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Opciones de entrada',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                onEditEntry(index);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'note_add',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
              title: const Text('Añadir nota'),
              onTap: () {
                Navigator.pop(context);
                onAddNote(index);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: const Text('Eliminar'),
              onTap: () {
                Navigator.pop(context);
                onDeleteEntry(index);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
