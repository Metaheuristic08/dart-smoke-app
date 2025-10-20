import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BreathingExerciseModal extends StatefulWidget {
  const BreathingExerciseModal({Key? key}) : super(key: key);

  @override
  State<BreathingExerciseModal> createState() => _BreathingExerciseModalState();
}

class _BreathingExerciseModalState extends State<BreathingExerciseModal>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _timerController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _scaleAnimation;

  bool _isActive = false;
  int _currentCycle = 0;
  int _totalCycles = 5;
  String _currentPhase = 'Preparándose...';
  int _remainingTime = 300; // 5 minutes in seconds

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _breathingController = AnimationController(
      duration: const Duration(seconds: 8), // 4 seconds in, 4 seconds out
      vsync: this,
    );

    _timerController = AnimationController(
      duration: Duration(seconds: _remainingTime),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentCycle++;
          if (_currentCycle >= _totalCycles) {
            _stopExercise();
          }
        });
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed && _isActive) {
        _breathingController.forward();
      }
    });

    _breathingAnimation.addListener(() {
      setState(() {
        if (_breathingAnimation.value < 0.5) {
          _currentPhase = 'Inhala...';
        } else {
          _currentPhase = 'Exhala...';
        }
      });
    });

    _timerController.addListener(() {
      setState(() {
        _remainingTime = (300 * (1 - _timerController.value)).round();
      });
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _isActive = true;
      _currentCycle = 0;
      _currentPhase = 'Inhala...';
    });
    _breathingController.forward();
    _timerController.forward();
  }

  void _stopExercise() {
    setState(() {
      _isActive = false;
      _currentPhase = 'Completado';
    });
    _breathingController.stop();
    _timerController.stop();
  }

  void _resetExercise() {
    setState(() {
      _isActive = false;
      _currentCycle = 0;
      _currentPhase = 'Preparándose...';
      _remainingTime = 300;
    });
    _breathingController.reset();
    _timerController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'air',
                  color: AppTheme.primaryLight,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Ejercicio de Respiración',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondaryLight,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Breathing animation circle
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryLight.withValues(alpha: 0.3),
                            AppTheme.primaryLight.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                        border: Border.all(
                          color: AppTheme.primaryLight,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPhase,
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryLight,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${_currentCycle}/${_totalCycles}',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Timer and controls
          Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Timer
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.textSecondaryLight,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Control buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetExercise,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          side: BorderSide(color: AppTheme.primaryLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Reiniciar',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.primaryLight,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isActive ? _stopExercise : _startExercise,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isActive
                              ? AppTheme.errorLight
                              : AppTheme.primaryLight,
                          foregroundColor: AppTheme.onPrimaryLight,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isActive ? 'Detener' : 'Comenzar',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.onPrimaryLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
