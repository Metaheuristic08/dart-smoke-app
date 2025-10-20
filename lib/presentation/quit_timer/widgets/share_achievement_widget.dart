import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ShareAchievementWidget extends StatelessWidget {
  final Duration quitDuration;
  final String currentMilestone;

  const ShareAchievementWidget({
    Key? key,
    required this.quitDuration,
    required this.currentMilestone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  '¡Comparte tu Progreso!',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Inspira a otros compartiendo tu logro de estar libre de humo.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareButton(
                context,
                'Copiar Texto',
                'content_copy',
                () => _copyToClipboard(context),
              ),
              _buildShareButton(
                context,
                'Compartir',
                'ios_share',
                () => _shareAchievement(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    final shareText = _generateShareText();
    Clipboard.setData(ClipboardData(text: shareText));

    Fluttertoast.showToast(
      msg: "Texto copiado al portapapeles",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: AppTheme.lightTheme.colorScheme.onPrimary,
    );
  }

  void _shareAchievement(BuildContext context) {
    final shareText = _generateShareText();

    // Note: In a real implementation, you would use share_plus package
    // For now, we'll show a dialog with the share text
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Compartir Logro',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Text(
            shareText,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _copyToClipboard(context);
              },
              child: Text('Copiar'),
            ),
          ],
        );
      },
    );
  }

  String _generateShareText() {
    final days = quitDuration.inDays;
    final hours = quitDuration.inHours;
    final minutes = quitDuration.inMinutes;

    String timeText;
    if (days > 0) {
      timeText = '$days ${days == 1 ? 'día' : 'días'}';
    } else if (hours > 0) {
      timeText = '$hours ${hours == 1 ? 'hora' : 'horas'}';
    } else {
      timeText = '$minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    }

    return '🚭 ¡Llevo $timeText libre de humo! $currentMilestone\n\n'
        '💪 Cada día sin fumar es una victoria para mi salud.\n'
        '#LibreDeHumo #SaludPrimero #SinTabaco';
  }
}
