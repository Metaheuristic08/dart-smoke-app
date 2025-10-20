import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CravingTimer extends StatefulWidget {
  final VoidCallback onCravingPassed;

  const CravingTimer({
    Key? key,
    required this.onCravingPassed,
  }) : super(key: key);

  @override
  State<CravingTimer> createState() => _CravingTimerState();
}

class _CravingTimerState extends State<CravingTimer>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late Animation<double> _progressAnimation;

  bool _isTimerActive = false;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    _timerController = AnimationController(
      duration: const Duration(minutes: 10), // 10 minute timer
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _timerController,
      curve: Curves.linear,
    ));

    _timerController.addListener(() {
      setState(() {
        _elapsedSeconds =
            (_timerController.value * 600).round(); // 600 seconds = 10 minutes
      });
    });

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _completeCravingSession();
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isTimerActive = true;
    });
    _timerController.forward();
  }

  void _stopTimer() {
    setState(() {
      _isTimerActive = false;
    });
    _timerController.stop();
  }

  void _resetTimer() {
    setState(() {
      _isTimerActive = false;
      _elapsedSeconds = 0;
    });
    _timerController.reset();
  }

  void _completeCravingSession() {
    setState(() {
      _isTimerActive = false;
    });

    // Show celebration animation
    _showCelebrationDialog();
  }

  void _showCelebrationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'celebration',
              color: AppTheme.successLight,
              size: 28,
            ),
            SizedBox(width: 3.w),
            Text(
              '¡Felicitaciones!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.successLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Has superado exitosamente tu antojo. ¡Cada victoria cuenta en tu camino hacia una vida más saludable!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onCravingPassed();
              _resetTimer();
            },
            child: Text(
              'Continuar',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

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
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'timer',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Cronómetro de Antojo',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Circular progress indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 40.w,
                height: 40.w,
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return CircularProgressIndicator(
                      value: _progressAnimation.value,
                      strokeWidth: 8,
                      backgroundColor: AppTheme.dividerLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isTimerActive
                            ? AppTheme.primaryLight
                            : AppTheme.successLight,
                      ),
                    );
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_elapsedSeconds),
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  Text(
                    _isTimerActive ? 'En progreso' : 'Detenido',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Control buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetTimer,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(color: AppTheme.primaryLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Reiniciar',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryLight,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isTimerActive ? _stopTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTimerActive
                        ? AppTheme.errorLight
                        : AppTheme.primaryLight,
                    foregroundColor: AppTheme.onPrimaryLight,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isTimerActive ? 'Pausar' : 'Iniciar',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.onPrimaryLight,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Craving passed button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showCelebrationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Antojo Superado',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
