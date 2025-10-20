import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/breathing_exercise_modal.dart';
import './widgets/craving_history_section.dart';
import './widgets/craving_intensity_slider.dart';
import './widgets/craving_timer.dart';
import './widgets/technique_card.dart';

class CravingManagement extends StatefulWidget {
  const CravingManagement({Key? key}) : super(key: key);

  @override
  State<CravingManagement> createState() => _CravingManagementState();
}

class _CravingManagementState extends State<CravingManagement> {
  double _currentIntensity = 5.0;
  bool _showEmergencySupport = false;

  final List<Map<String, dynamic>> _techniques = [
    {
      "id": 1,
      "title": "Respiración 4-7-8",
      "description":
          "Técnica de respiración profunda para calmar la ansiedad y reducir el estrés inmediatamente.",
      "duration": "5 min",
      "difficulty": "Fácil",
      "category": "Respiración",
      "icon": Icons.air,
      "type": "breathing"
    },
    {
      "id": 2,
      "title": "Caminata Rápida",
      "description":
          "Actividad física ligera para liberar endorfinas y distraer la mente del antojo.",
      "duration": "10 min",
      "difficulty": "Fácil",
      "category": "Actividad Física",
      "icon": Icons.directions_run,
      "type": "physical"
    },
    {
      "id": 3,
      "title": "Juego de Memoria",
      "description":
          "Ejercicio mental que requiere concentración para desviar la atención del antojo.",
      "duration": "8 min",
      "difficulty": "Medio",
      "category": "Distracción Mental",
      "icon": Icons.psychology,
      "type": "mental"
    },
    {
      "id": 4,
      "title": "Llamar a un Amigo",
      "description":
          "Conecta con tu red de apoyo para recibir motivación y distracción social.",
      "duration": "15 min",
      "difficulty": "Fácil",
      "category": "Apoyo Social",
      "icon": Icons.people,
      "type": "social"
    },
    {
      "id": 5,
      "title": "Meditación Guiada",
      "description":
          "Sesión de mindfulness para observar el antojo sin juzgar y dejarlo pasar.",
      "duration": "12 min",
      "difficulty": "Medio",
      "category": "Respiración",
      "icon": Icons.air,
      "type": "breathing"
    },
    {
      "id": 6,
      "title": "Ejercicios de Estiramiento",
      "description":
          "Movimientos suaves para liberar tensión física y mental acumulada.",
      "duration": "7 min",
      "difficulty": "Fácil",
      "category": "Actividad Física",
      "icon": Icons.directions_run,
      "type": "physical"
    },
  ];

  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      "name": "Línea de Ayuda Nacional",
      "phone": "900-123-456",
      "description": "Apoyo 24/7 para crisis de adicción",
      "type": "hotline"
    },
    {
      "name": "Dr. María González",
      "phone": "600-789-123",
      "description": "Tu médico de confianza",
      "type": "doctor"
    },
    {
      "name": "Grupo de Apoyo Local",
      "phone": "650-456-789",
      "description": "Comunidad de personas en recuperación",
      "type": "support_group"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimaryLight,
            size: 24,
          ),
        ),
        title: Text(
          'Gestión de Antojos',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showEmergencyDialog(),
            icon: CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.errorLight,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),

            // Emergency alert banner (if high intensity)
            if (_currentIntensity >= 8) _buildEmergencyBanner(),

            // Craving intensity slider
            CravingIntensitySlider(
              intensity: _currentIntensity,
              onIntensityChanged: (value) {
                setState(() {
                  _currentIntensity = value;
                });
              },
            ),

            // Craving timer
            CravingTimer(
              onCravingPassed: () {
                _showSuccessMessage();
              },
            ),

            // Techniques section header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.primaryLight,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Técnicas de Manejo',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_techniques.length} disponibles',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Techniques grid
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _techniques.length,
              itemBuilder: (context, index) {
                final technique = _techniques[index];
                return TechniqueCard(
                  title: technique["title"] as String,
                  description: technique["description"] as String,
                  duration: technique["duration"] as String,
                  difficulty: technique["difficulty"] as String,
                  category: technique["category"] as String,
                  icon: technique["icon"] as IconData,
                  onTap: () => _handleTechniqueSelection(technique),
                );
              },
            ),

            SizedBox(height: 2.h),

            // Quick access emergency support
            if (_showEmergencySupport || _currentIntensity >= 7)
              _buildEmergencySupport(),

            // Craving history section
            const CravingHistorySection(),

            SizedBox(height: 4.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickTechniqueDialog(),
        backgroundColor: AppTheme.primaryLight,
        foregroundColor: AppTheme.onPrimaryLight,
        icon: CustomIconWidget(
          iconName: 'flash_on',
          color: AppTheme.onPrimaryLight,
          size: 20,
        ),
        label: Text(
          'Técnica Rápida',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.onPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyBanner() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.errorLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.errorLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: AppTheme.errorLight,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Antojo Intenso Detectado',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.errorLight,
                  ),
                ),
                Text(
                  'Considera usar técnicas de emergencia o contactar apoyo.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showEmergencyDialog(),
            child: Text(
              'Ayuda',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.errorLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySupport() {
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'support_agent',
                color: AppTheme.errorLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Apoyo de Emergencia',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _emergencyContacts.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final contact = _emergencyContacts[index];
              return _buildEmergencyContactItem(contact);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactItem(Map<String, dynamic> contact) {
    final String name = contact["name"] as String;
    final String phone = contact["phone"] as String;
    final String description = contact["description"] as String;
    final String type = contact["type"] as String;

    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'hotline':
        iconData = Icons.phone;
        iconColor = AppTheme.errorLight;
        break;
      case 'doctor':
        iconData = Icons.local_hospital;
        iconColor = AppTheme.primaryLight;
        break;
      case 'support_group':
        iconData = Icons.group;
        iconColor = AppTheme.accentLight;
        break;
      default:
        iconData = Icons.contact_phone;
        iconColor = AppTheme.textSecondaryLight;
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getIconName(iconData),
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                Text(
                  phone,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _callEmergencyContact(phone),
            icon: CustomIconWidget(
              iconName: 'call',
              color: AppTheme.primaryLight,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _getIconName(IconData iconData) {
    if (iconData == Icons.phone) return 'phone';
    if (iconData == Icons.local_hospital) return 'local_hospital';
    if (iconData == Icons.group) return 'group';
    return 'contact_phone';
  }

  void _handleTechniqueSelection(Map<String, dynamic> technique) {
    final String type = technique["type"] as String;

    switch (type) {
      case 'breathing':
        _showBreathingExercise();
        break;
      case 'physical':
        _startPhysicalActivity(technique);
        break;
      case 'mental':
        _startMentalDistraction(technique);
        break;
      case 'social':
        _initiateSocialSupport(technique);
        break;
    }
  }

  void _showBreathingExercise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BreathingExerciseModal(),
    );
  }

  void _startPhysicalActivity(Map<String, dynamic> technique) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'directions_run',
              color: AppTheme.accentLight,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              technique["title"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              technique["description"] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Consejos:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '• Mantén un ritmo cómodo\n• Respira profundamente\n• Concéntrate en el movimiento',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startActivityTimer(technique);
            },
            child: Text('Comenzar'),
          ),
        ],
      ),
    );
  }

  void _startMentalDistraction(Map<String, dynamic> technique) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.successLight,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Juego Mental',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Piensa en 5 cosas que puedas ver, 4 que puedas tocar, 3 que puedas oír, 2 que puedas oler y 1 que puedas saborear.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.secondaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Esta técnica te ayuda a conectar con el presente y distraer tu mente del antojo.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage();
            },
            child: Text('Completado'),
          ),
        ],
      ),
    );
  }

  void _initiateSocialSupport(Map<String, dynamic> technique) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'people',
              color: AppTheme.errorLight,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Apoyo Social',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Conectar con alguien de confianza puede ayudarte a superar este momento difícil. ¿A quién te gustaría contactar?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEmergencyDialog();
            },
            child: Text('Ver Contactos'),
          ),
        ],
      ),
    );
  }

  void _startActivityTimer(Map<String, dynamic> technique) {
    // Start a timer for the activity
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Iniciando ${technique["title"]} - ${technique["duration"]}'),
        backgroundColor: AppTheme.accentLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Completado',
          textColor: Colors.white,
          onPressed: () => _showSuccessMessage(),
        ),
      ),
    );
  }

  void _showQuickTechniqueDialog() {
    final quickTechniques = _techniques.take(3).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Técnicas Rápidas',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ...quickTechniques
                .map((technique) => ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: _getTechniqueIconName(
                              technique["icon"] as IconData),
                          color: AppTheme.primaryLight,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        technique["title"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(technique["duration"] as String),
                      onTap: () {
                        Navigator.pop(context);
                        _handleTechniqueSelection(
                            technique);
                      },
                    ))
                .toList(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getTechniqueIconName(IconData iconData) {
    if (iconData == Icons.air) return 'air';
    if (iconData == Icons.directions_run) return 'directions_run';
    if (iconData == Icons.psychology) return 'psychology';
    if (iconData == Icons.people) return 'people';
    return 'help_outline';
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.errorLight,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Apoyo de Emergencia',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.errorLight,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Si sientes que necesitas ayuda inmediata, no dudes en contactar a los siguientes recursos:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            ..._emergencyContacts
                .map((contact) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.primaryLight,
                        size: 20,
                      ),
                      title: Text(
                        contact["name"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(contact["phone"] as String),
                      onTap: () =>
                          _callEmergencyContact(contact["phone"] as String),
                    ))
                .toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _showEmergencySupport = true;
              });
            },
            child: Text('Mostrar Apoyo'),
          ),
        ],
      ),
    );
  }

  void _callEmergencyContact(String phone) {
    // In a real app, this would use url_launcher to make a phone call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Llamando a $phone...'),
        backgroundColor: AppTheme.primaryLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('¡Excelente trabajo! Has superado tu antojo.'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
