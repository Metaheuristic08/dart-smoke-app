import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './metrics_card_widget.dart';

class InsightsScrollWidget extends StatelessWidget {
  const InsightsScrollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> insightsData = [
      {
        'title': 'Promedio Diario',
        'value': '12',
        'subtitle': '3 menos que ayer',
        'iconName': 'trending_down',
        'backgroundColor': AppTheme.lightTheme.colorScheme.surface,
      },
      {
        'title': 'Racha Más Larga',
        'value': '5 días',
        'subtitle': 'Sin fumar',
        'iconName': 'emoji_events',
        'backgroundColor': AppTheme.lightTheme.colorScheme.surface,
      },
      {
        'title': 'Mejora',
        'value': '23%',
        'subtitle': 'Reducción este mes',
        'iconName': 'trending_up',
        'backgroundColor': AppTheme.lightTheme.colorScheme.surface,
      },
      {
        'title': 'Dinero Ahorrado',
        'value': '€45',
        'subtitle': 'Esta semana',
        'iconName': 'savings',
        'backgroundColor': AppTheme.lightTheme.colorScheme.surface,
      },
      {
        'title': 'Tiempo Ganado',
        'value': '2.5h',
        'subtitle': 'Vida recuperada',
        'iconName': 'schedule',
        'backgroundColor': AppTheme.lightTheme.colorScheme.surface,
      },
      {
        'title': 'Disparadores',
        'value': 'Estrés',
        'subtitle': 'Principal causa',
        'iconName': 'psychology',
        'backgroundColor': AppTheme.lightTheme.colorScheme.surface,
      },
    ];

    return Container(
      height: 22.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Métricas Clave',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: insightsData.length,
              itemBuilder: (context, index) {
                final insight = insightsData[index];
                return Container(
                  margin: EdgeInsets.only(right: 3.w),
                  child: MetricsCardWidget(
                    title: insight['title'] as String,
                    value: insight['value'] as String,
                    subtitle: insight['subtitle'] as String,
                    iconName: insight['iconName'] as String,
                    backgroundColor: insight['backgroundColor'] as Color?,
                    onTap: () {
                      _showInsightDetails(context, insight);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showInsightDetails(BuildContext context, Map<String, dynamic> insight) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: insight['iconName'] as String,
                          color: AppTheme.lightTheme.primaryColor,
                          size: 6.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              insight['title'] as String,
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              insight['value'] as String,
                              style: AppTheme
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Detalles',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _getDetailedDescription(insight['title'] as String),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDetailedDescription(String title) {
    switch (title) {
      case 'Promedio Diario':
        return 'Tu consumo promedio diario ha disminuido significativamente. Continúa con este progreso positivo para alcanzar tus objetivos de salud.';
      case 'Racha Más Larga':
        return 'Has logrado mantenerte sin fumar durante 5 días consecutivos. Esta es tu mejor racha hasta ahora. ¡Sigue así!';
      case 'Mejora':
        return 'Has reducido tu consumo en un 23% este mes comparado con el mes anterior. Esta mejora constante es clave para tu éxito.';
      case 'Dinero Ahorrado':
        return 'Al reducir tu consumo, has ahorrado €45 esta semana. Este dinero puede ser invertido en actividades más saludables.';
      case 'Tiempo Ganado':
        return 'Cada cigarrillo que no fumas te devuelve aproximadamente 11 minutos de vida. Has ganado 2.5 horas esta semana.';
      case 'Disparadores':
        return 'El estrés es tu principal disparador para fumar. Considera técnicas de relajación y manejo del estrés para reducir este impulso.';
      default:
        return 'Información detallada sobre esta métrica.';
    }
  }
}
