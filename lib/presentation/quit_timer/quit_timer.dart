import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emergency_support_widget.dart';
import './widgets/milestone_card_widget.dart';
import './widgets/share_achievement_widget.dart';
import './widgets/timer_display_widget.dart';

class QuitTimer extends StatefulWidget {
  const QuitTimer({Key? key}) : super(key: key);

  @override
  State<QuitTimer> createState() => _QuitTimerState();
}

class _QuitTimerState extends State<QuitTimer> with TickerProviderStateMixin {
  Timer? _timer;
  DateTime? _quitStartTime;
  Duration _quitDuration = Duration.zero;
  PageController _pageController = PageController();
  int _currentMilestoneIndex = 0;

  // Mock milestones data
  final List<Map<String, dynamic>> _milestones = [
    {
      "id": 1,
      "title": "Primeros 20 Minutos",
      "timeframe": "0-20 minutos",
      "description":
          "Tu ritmo cardíaco y presión arterial comienzan a normalizarse después de dejar de fumar.",
      "healthBenefit": "Mejora la circulación sanguínea",
      "icon": "favorite",
      "requiredMinutes": 20,
    },
    {
      "id": 2,
      "title": "Primera Hora",
      "timeframe": "1 hora",
      "description":
          "Los niveles de monóxido de carbono en tu sangre comienzan a disminuir significativamente.",
      "healthBenefit": "Mejor oxigenación celular",
      "icon": "air",
      "requiredMinutes": 60,
    },
    {
      "id": 3,
      "title": "Primer Día",
      "timeframe": "24 horas",
      "description":
          "El riesgo de ataque cardíaco comienza a disminuir. Tu cuerpo elimina el monóxido de carbono.",
      "healthBenefit": "Reducción del riesgo cardíaco",
      "icon": "health_and_safety",
      "requiredMinutes": 1440,
    },
    {
      "id": 4,
      "title": "Dos Días",
      "timeframe": "48 horas",
      "description":
          "Las terminaciones nerviosas comienzan a regenerarse. Tu sentido del gusto y olfato mejoran.",
      "healthBenefit": "Recuperación sensorial",
      "icon": "restaurant",
      "requiredMinutes": 2880,
    },
    {
      "id": 5,
      "title": "Tres Días",
      "timeframe": "72 horas",
      "description":
          "La nicotina se elimina completamente de tu cuerpo. Respirar se vuelve más fácil.",
      "healthBenefit": "Cuerpo libre de nicotina",
      "icon": "clean_hands",
      "requiredMinutes": 4320,
    },
    {
      "id": 6,
      "title": "Una Semana",
      "timeframe": "7 días",
      "description":
          "Has superado la fase más difícil. Tu riesgo de recaída disminuye significativamente.",
      "healthBenefit": "Mayor capacidad pulmonar",
      "icon": "celebration",
      "requiredMinutes": 10080,
    },
    {
      "id": 7,
      "title": "Un Mes",
      "timeframe": "30 días",
      "description":
          "La función pulmonar mejora notablemente. Menos tos y dificultad para respirar.",
      "healthBenefit": "Pulmones más saludables",
      "icon": "emoji_events",
      "requiredMinutes": 43200,
    },
    {
      "id": 8,
      "title": "Tres Meses",
      "timeframe": "90 días",
      "description":
          "La circulación mejora y la función pulmonar aumenta hasta un 30%.",
      "healthBenefit": "Mejora circulatoria significativa",
      "icon": "workspace_premium",
      "requiredMinutes": 129600,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadQuitStartTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuitStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    final quitTimeString = prefs.getString('quit_start_time');

    if (quitTimeString != null) {
      _quitStartTime = DateTime.parse(quitTimeString);
    } else {
      // Set default quit time to current time if not set
      _quitStartTime = DateTime.now();
      await _saveQuitStartTime();
    }

    _updateQuitDuration();
  }

  Future<void> _saveQuitStartTime() async {
    if (_quitStartTime != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'quit_start_time', _quitStartTime!.toIso8601String());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateQuitDuration();
    });
  }

  void _updateQuitDuration() {
    if (_quitStartTime != null) {
      setState(() {
        _quitDuration = DateTime.now().difference(_quitStartTime!);
        _updateCurrentMilestone();
      });
    }
  }

  void _updateCurrentMilestone() {
    final totalMinutes = _quitDuration.inMinutes;

    for (int i = 0; i < _milestones.length; i++) {
      if (totalMinutes >= (_milestones[i]['requiredMinutes'] as int)) {
        _currentMilestoneIndex = i;
      } else {
        break;
      }
    }
  }

  double _getProgress() {
    final totalMinutes = _quitDuration.inMinutes;

    // Find next milestone
    int nextMilestoneIndex = _currentMilestoneIndex;
    if (_currentMilestoneIndex < _milestones.length - 1) {
      nextMilestoneIndex = _currentMilestoneIndex + 1;
    }

    final currentMilestoneMinutes = _currentMilestoneIndex > 0
        ? _milestones[_currentMilestoneIndex - 1]['requiredMinutes'] as int
        : 0;
    final nextMilestoneMinutes =
        _milestones[nextMilestoneIndex]['requiredMinutes'] as int;

    if (totalMinutes >= nextMilestoneMinutes) {
      return 1.0;
    }

    final progress = (totalMinutes - currentMilestoneMinutes) /
        (nextMilestoneMinutes - currentMilestoneMinutes);

    return progress.clamp(0.0, 1.0);
  }

  void _showResetConfirmation() {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Reiniciar Temporizador',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Text(
            '¿Estás seguro de que quieres reiniciar tu progreso? Esta acción no se puede deshacer.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text(
                'Reiniciar',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onError,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetTimer() async {
    setState(() {
      _quitStartTime = DateTime.now();
      _quitDuration = Duration.zero;
      _currentMilestoneIndex = 0;
    });

    await _saveQuitStartTime();

    HapticFeedback.lightImpact();
  }

  void _navigateToCravingManagement() {
    Navigator.pushNamed(context, '/craving-management');
  }

  void _navigateToCommunitySupport() {
    // In a real app, this would navigate to community features
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Función de comunidad próximamente'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  String _getCurrentMilestoneTitle() {
    if (_currentMilestoneIndex < _milestones.length) {
      return _milestones[_currentMilestoneIndex]['title'] as String;
    }
    return '¡Campeón sin humo!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Temporizador de Libertad',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/dashboard-home'),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/progress-analytics'),
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              SizedBox(height: 3.h),

              // Timer Display
              TimerDisplayWidget(
                quitDuration: _quitDuration,
                progress: _getProgress(),
              ),

              SizedBox(height: 4.h),

              // Milestone Cards Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text(
                      'Hitos de Salud',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Milestone Cards Carousel
                  SizedBox(
                    height: 25.h,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _milestones.length,
                      itemBuilder: (context, index) {
                        final milestone = _milestones[index];
                        final requiredMinutes =
                            milestone['requiredMinutes'] as int;
                        final isUnlocked =
                            _quitDuration.inMinutes >= requiredMinutes;
                        final isNext = index == _currentMilestoneIndex + 1 ||
                            (index == _currentMilestoneIndex && !isUnlocked);

                        return GestureDetector(
                          onLongPress: () => _showMilestoneDetails(milestone),
                          child: MilestoneCardWidget(
                            milestone: milestone,
                            isUnlocked: isUnlocked,
                            isNext: isNext,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // Emergency Support Section
              EmergencySupportWidget(
                onCravingManagement: _navigateToCravingManagement,
                onCommunitySupport: _navigateToCommunitySupport,
              ),

              SizedBox(height: 4.h),

              // Share Achievement Section
              ShareAchievementWidget(
                quitDuration: _quitDuration,
                currentMilestone: _getCurrentMilestoneTitle(),
              ),

              SizedBox(height: 4.h),

              // Reset Timer Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showResetConfirmation,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 5.w,
                  ),
                  label: Text(
                    'Reiniciar Temporizador',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.error,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.error,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showMilestoneDetails(Map<String, dynamic> milestone) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: milestone['icon'] as String,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  milestone['title'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiempo requerido: ${milestone['timeframe']}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                milestone['description'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              if (milestone['healthBenefit'] != null) ...[
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'favorite',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Beneficio: ${milestone['healthBenefit']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
