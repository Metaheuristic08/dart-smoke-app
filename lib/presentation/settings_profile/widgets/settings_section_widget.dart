import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  const SettingsSectionWidget({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              indent: 4.w,
              endIndent: 4.w,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildSettingsItem(
                  context, item, index == items.length - 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context, SettingsItem item, bool isLast) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.vertical(
        bottom: isLast ? Radius.circular(16) : Radius.zero,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            if (item.iconName != null) ...[
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: item.iconColor?.withValues(alpha: 0.1) ??
                      AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: item.iconName!,
                  size: 5.w,
                  color:
                      item.iconColor ?? AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                  if (item.subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      item.subtitle!,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.trailing != null)
              item.trailing!
            else if (item.hasSwitch)
              Switch(
                value: item.switchValue ?? false,
                onChanged: item.onSwitchChanged,
              )
            else if (item.showChevron)
              CustomIconWidget(
                iconName: 'chevron_right',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class SettingsItem {
  final String title;
  final String? subtitle;
  final String? iconName;
  final Color? iconColor;
  final bool hasSwitch;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showChevron;

  SettingsItem({
    required this.title,
    this.subtitle,
    this.iconName,
    this.iconColor,
    this.hasSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
    this.onTap,
    this.trailing,
    this.showChevron = true,
  });
}
