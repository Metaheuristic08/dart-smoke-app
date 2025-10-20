import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../../core/app_export.dart';

class DataExportWidget extends StatefulWidget {
  const DataExportWidget({Key? key}) : super(key: key);

  @override
  State<DataExportWidget> createState() => _DataExportWidgetState();
}

class _DataExportWidgetState extends State<DataExportWidget> {
  bool _isExporting = false;

  final List<Map<String, dynamic>> _mockUserData = [
    {
      "fecha": "2024-10-15",
      "cigarrillos_fumados": 12,
      "dinero_gastado": 6.0,
      "antojos_registrados": 8,
      "tiempo_sin_fumar_horas": 0,
      "notas": "Día difícil en el trabajo, más estrés de lo normal"
    },
    {
      "fecha": "2024-10-14",
      "cigarrillos_fumados": 10,
      "dinero_gastado": 5.0,
      "antojos_registrados": 6,
      "tiempo_sin_fumar_horas": 2,
      "notas": "Intenté reducir el consumo, logré evitar algunos cigarrillos"
    },
    {
      "fecha": "2024-10-13",
      "cigarrillos_fumados": 15,
      "dinero_gastado": 7.5,
      "antojos_registrados": 12,
      "tiempo_sin_fumar_horas": 0,
      "notas": "Día social, fumé más de lo habitual"
    },
  ];

  Future<void> _exportData(String format) async {
    setState(() => _isExporting = true);

    try {
      String content;
      String filename;

      switch (format) {
        case 'CSV':
          content = _generateCSV();
          filename =
              'datos_smoke_tracker_${DateTime.now().millisecondsSinceEpoch}.csv';
          break;
        case 'JSON':
          content = _generateJSON();
          filename =
              'datos_smoke_tracker_${DateTime.now().millisecondsSinceEpoch}.json';
          break;
        default:
          content = _generateTXT();
          filename =
              'datos_smoke_tracker_${DateTime.now().millisecondsSinceEpoch}.txt';
      }

      await _downloadFile(content, filename);
      _showSuccessMessage('Datos exportados exitosamente como $filename');
    } catch (e) {
      _showErrorMessage('Error al exportar datos: ${e.toString()}');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  String _generateCSV() {
    final headers =
        'Fecha,Cigarrillos Fumados,Dinero Gastado (€),Antojos,Tiempo Sin Fumar (h),Notas\n';
    final rows = (_mockUserData as List).map((item) {
      final data = item as Map<String, dynamic>;
      return '${data["fecha"]},${data["cigarrillos_fumados"]},${data["dinero_gastado"]},${data["antojos_registrados"]},${data["tiempo_sin_fumar_horas"]},"${data["notas"]}"';
    }).join('\n');
    return headers + rows;
  }

  String _generateJSON() {
    final exportData = {
      'usuario': 'Carlos Rodríguez',
      'fecha_exportacion': DateTime.now().toIso8601String(),
      'datos_seguimiento': _mockUserData,
      'resumen': {
        'total_dias_registrados': _mockUserData.length,
        'promedio_cigarrillos_dia': (_mockUserData as List)
                .map((item) => (item
                    as Map<String, dynamic>)["cigarrillos_fumados"] as int)
                .reduce((a, b) => a + b) /
            _mockUserData.length,
        'total_dinero_gastado': (_mockUserData as List)
            .map((item) =>
                (item as Map<String, dynamic>)["dinero_gastado"] as double)
            .reduce((a, b) => a + b),
      }
    };
    return JsonEncoder.withIndent('  ').convert(exportData);
  }

  String _generateTXT() {
    final buffer = StringBuffer();
    buffer.writeln('REPORTE DE SEGUIMIENTO - SMOKE TRACKER');
    buffer.writeln('=====================================');
    buffer.writeln('Usuario: Carlos Rodríguez');
    buffer.writeln(
        'Fecha de exportación: ${DateTime.now().toString().split('.')[0]}');
    buffer.writeln('');

    for (final item in _mockUserData) {
      final data = item;
      buffer.writeln('Fecha: ${data["fecha"]}');
      buffer.writeln('Cigarrillos fumados: ${data["cigarrillos_fumados"]}');
      buffer.writeln('Dinero gastado: €${data["dinero_gastado"]}');
      buffer.writeln('Antojos registrados: ${data["antojos_registrados"]}');
      buffer
          .writeln('Tiempo sin fumar: ${data["tiempo_sin_fumar_horas"]} horas');
      buffer.writeln('Notas: ${data["notas"]}');
      buffer.writeln('---');
    }

    return buffer.toString();
  }

  Future<void> _downloadFile(String exportContent, String filename) async {
    if (kIsWeb) {
      final url = html.Url.createObjectUrlFromBlob(html.Blob([utf8.encode(exportContent)]));
      html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(exportContent);
    }
  }

  Future<void> _importData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'json', 'txt'],
      );

      if (result != null) {
        final bytes = kIsWeb
            ? result.files.first.bytes
            : await File(result.files.first.path!).readAsBytes();
        if (bytes != null) {
          // ignore: unused_local_variable
          final content = utf8.decode(bytes);
          _showSuccessMessage(
              'Datos importados exitosamente desde ${result.files.first.name}');
        }
      }
    } catch (e) {
      _showErrorMessage('Error al importar datos: ${e.toString()}');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'download',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 3.w),
              Text(
                'Gestión de Datos',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Exporta tus datos de seguimiento para compartir con profesionales de la salud o crear respaldos.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Formatos de Exportación',
            style: AppTheme.lightTheme.textTheme.titleSmall,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildExportButton(
                  'CSV',
                  'Hoja de cálculo',
                  'table_chart',
                  () => _exportData('CSV'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildExportButton(
                  'JSON',
                  'Datos estructurados',
                  'code',
                  () => _exportData('JSON'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildExportButton(
                  'TXT',
                  'Texto plano',
                  'description',
                  () => _exportData('TXT'),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2)),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _importData,
              icon: CustomIconWidget(
                iconName: 'upload',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              label: Text('Importar Datos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(
    String format,
    String description,
    String iconName,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: _isExporting ? null : onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: _isExporting
              ? AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            _isExporting
                ? SizedBox(
                    width: 6.w,
                    height: 6.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  )
                : CustomIconWidget(
                    iconName: iconName,
                    size: 6.w,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
            SizedBox(height: 1.h),
            Text(
              format,
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
