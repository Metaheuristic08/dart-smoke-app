import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CravingIntensitySlider extends StatefulWidget {
  final double intensity;
  final Function(double) onIntensityChanged;

  const CravingIntensitySlider({
    Key? key,
    required this.intensity,
    required this.onIntensityChanged,
  }) : super(key: key);

  @override
  State<CravingIntensitySlider> createState() => _CravingIntensitySliderState();
}

class _CravingIntensitySliderState extends State<CravingIntensitySlider> {
  @override
  Widget build(BuildContext context) {
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
          Text(
            'Intensidad del Antojo',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                '1',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
              Expanded(
                child: Slider(
                  value: widget.intensity,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  activeColor: _getIntensityColor(widget.intensity),
                  inactiveColor: AppTheme.dividerLight,
                  onChanged: widget.onIntensityChanged,
                ),
              ),
              Text(
                '10',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    _getIntensityColor(widget.intensity).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${widget.intensity.round()}/10 - ${_getIntensityLabel(widget.intensity)}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getIntensityColor(widget.intensity),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _logCraving(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryLight,
                foregroundColor: AppTheme.onPrimaryLight,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Registrar Antojo',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.onPrimaryLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getIntensityColor(double intensity) {
    if (intensity <= 3) {
      return AppTheme.successLight;
    } else if (intensity <= 6) {
      return AppTheme.accentLight;
    } else {
      return AppTheme.errorLight;
    }
  }

  String _getIntensityLabel(double intensity) {
    if (intensity <= 3) {
      return 'Leve';
    } else if (intensity <= 6) {
      return 'Moderado';
    } else {
      return 'Intenso';
    }
  }

  void _logCraving() {
    // Log craving with timestamp
    final now = DateTime.now();
    // Here you would typically save to local storage or send to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Antojo registrado: ${widget.intensity.round()}/10 a las ${now.hour}:${now.minute.toString().padLeft(2, '0')}'),
        backgroundColor: AppTheme.primaryLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
