import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/local_data_service.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/insights_scroll_widget.dart';
import './widgets/smoking_chart_widget.dart';

class ProgressAnalytics extends StatefulWidget {
  const ProgressAnalytics({Key? key}) : super(key: key);

  @override
  State<ProgressAnalytics> createState() => _ProgressAnalyticsState();
}

class _ProgressAnalyticsState extends State<ProgressAnalytics>
    with TickerProviderStateMixin {
  String selectedRange = 'Semanal';
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final LocalDataService _dataService = LocalDataService();

  // Local data
  List<Map<String, dynamic>> smokingData = [];
  List<Map<String, dynamic>> weeklyData = [];
  Map<String, dynamic> statistics = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      smokingData = await _dataService.getSmokingData();
      weeklyData = _dataService.getWeeklyProgressData();
      statistics = _dataService.calculateStatistics();
      _animationController.forward();
    } catch (e) {
      debugPrint('Error loading analytics data: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    await _loadData();

    setState(() {
      isLoading = false;
    });
  }

  void _exportData() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 35.h,
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exportar Datos Locales',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'picture_as_pdf',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 6.w,
                      ),
                      title: Text(
                        'Generar Reporte PDF',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Para compartir con profesionales de salud',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _generateLocalPDFReport();
                      },
                    ),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'table_chart',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 6.w,
                      ),
                      title: Text(
                        'Exportar como CSV',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Datos en formato de hoja de cálculo',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _exportLocalCSVData();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateLocalPDFReport() async {
    try {
      final jsonData = await _dataService.exportDataAsJSON();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Reporte generado localmente (${(jsonData.length / 1024).toStringAsFixed(1)} KB)'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'Ver',
            textColor: Colors.white,
            onPressed: () {
              _showDataPreview('PDF Report', jsonData);
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al generar reporte'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportLocalCSVData() async {
    try {
      final csvData = await _dataService.exportDataAsCSV();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'CSV exportado localmente (${(csvData.length / 1024).toStringAsFixed(1)} KB)'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'Ver',
            textColor: Colors.white,
            onPressed: () {
              _showDataPreview('CSV Data', csvData);
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al exportar CSV'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDataPreview(String title, String data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          width: double.maxFinite,
          height: 50.h,
          child: SingleChildScrollView(
            child: Text(
              data.substring(0, data.length > 1000 ? 1000 : data.length) +
                  (data.length > 1000
                      ? '...\n\n[Datos truncados para vista previa]'
                      : ''),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Análisis de Progreso',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _exportData,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(90.w, 10.h, 2.w, 0),
                items: [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'refresh',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        const Text('Actualizar datos'),
                      ],
                    ),
                    onTap: _refreshData,
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'storage',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        const Text('Datos locales'),
                      ],
                    ),
                    onTap: () {
                      _showLocalDataInfo();
                    },
                  ),
                ],
              );
            },
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppTheme.lightTheme.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Range Selector with better responsive design
                DateRangeSelectorWidget(
                  selectedRange: selectedRange,
                  onRangeSelected: (range) {
                    setState(() {
                      selectedRange = range;
                    });
                  },
                ),

                // Main Chart with improved responsiveness
                SmokingChartWidget(
                  selectedRange: selectedRange,
                ),

                // Key Metrics Scroll with local data
                InsightsScrollWidget(),

                // Filter Options
                const FilterChipsWidget(),

                // Additional Local Insights Section with improved layout
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Análisis Local Inteligente',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      _buildLocalInsightItem(
                        'Datos Privados',
                        'Tu información permanece 100% local',
                        'security',
                        Colors.green,
                      ),
                      SizedBox(height: 1.h),
                      _buildLocalInsightItem(
                        'Sin Internet',
                        'Funciona completamente offline',
                        'cloud_off',
                        AppTheme.lightTheme.primaryColor,
                      ),
                      SizedBox(height: 1.h),
                      if (statistics.isNotEmpty)
                        _buildLocalInsightItem(
                          'Progreso Total',
                          '${statistics['daysSinceQuit'] ?? 0} días de progreso registrado',
                          'trending_up',
                          Colors.orange,
                        ),
                    ],
                  ),
                ),

                // Bottom spacing for navigation
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        currentIndex: 1, // Progress tab is selected
        selectedFontSize: 12,
        unselectedFontSize: 10,
        iconSize: 5.w, // Improved icon size
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard-home');
              break;
            case 1:
              // Already on progress analytics
              break;
            case 2:
              Navigator.pushNamed(context, '/quit-timer');
              break;
            case 3:
              Navigator.pushNamed(context, '/craving-management');
              break;
            case 4:
              Navigator.pushNamed(context, '/settings-profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.primaryColor,
              size: 5.w,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.lightTheme.primaryColor,
              size: 5.w,
            ),
            label: 'Progreso',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'timer',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'timer',
              color: AppTheme.lightTheme.primaryColor,
              size: 5.w,
            ),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.lightTheme.primaryColor,
              size: 5.w,
            ),
            label: 'Antojos',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.primaryColor,
              size: 5.w,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildLocalInsightItem(
      String title, String description, String iconName, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 4.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLocalDataInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📱 Información de Datos Locales'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado de tus datos:\n\n'
              '📊 Entradas de seguimiento: ${smokingData.length}\n'
              '📈 Días de datos semanales: ${weeklyData.length}\n'
              '🏆 Logros registrados: ${statistics.isNotEmpty ? "Sí" : "No"}\n\n'
              '🔒 Almacenamiento: 100% local en tu dispositivo\n'
              '🌐 Conexión requerida: Ninguna\n'
              '💾 Persistencia: Los datos se mantienen entre sesiones',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}