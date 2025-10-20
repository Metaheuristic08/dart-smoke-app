# SmokeTracker - Flutter App

Un aplicación moderna de Flutter enfocada en **seguimiento de abandono del tabaco** y **gestión de antojos** con una arquitectura local (offline-first) y un diseño terapéutico minimalista.

## 📋 Características Principales

✅ **100% Local**: Sin conexión a internet requerida; todos tus datos se guardan en el dispositivo  
✅ **Seguimiento de Progreso**: Cronómetro, estadísticas diarias, logros desbloqueables  
✅ **Gestión de Antojos**: Técnicas de respiración, ejercicios mentales, apoyo social  
✅ **Análisis Detallados**: Gráficos semanales, historial de consumo, beneficios para la salud  
✅ **Diseño Responsivo**: Interfaz adaptable con Sizer para cualquier dispositivo  
✅ **Tema Personalizable**: Soporte para modo claro/oscuro con tipografía profesional  

## �️ Requisitos Previos

- **Flutter SDK** `^3.6.0`
- **Dart SDK** `^3.6.0`
- **Android SDK** (para emulador o dispositivo Android)
- **Xcode** (para iOS; opcional)

Verifica que Flutter esté correctamente instalado:
```bash
flutter doctor
```

## � Instalación

### 1. Clonar el Repositorio

```bash
cd path/to/project
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

## 🚀 Ejecución

### Ejecución Básica

```bash
flutter run
```

### Ejecución con Variables de Entorno

Si deseas pasar variables de entorno vía archivo `env.json`:

```bash
flutter run --dart-define-from-file=env.json
```

**Ejemplo de archivo `env.json`:**
```json
{
  "APP_VERSION": "1.0.0",
  "DEBUG_MODE": "true"
}
```

### Ejecución en Dispositivo o Emulador Específico

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device-id>
```

## 🏗️ Estructura del Proyecto

```
lib/
├── core/
│   ├── app_export.dart          # Exporta todas las dependencias globales
│   └── color_extensions.dart    # Extensión para manejo de transparencia
├── presentation/
│   ├── splash_screen/           # Pantalla de carga
│   ├── dashboard_home/          # Panel de control principal
│   ├── craving_management/      # Gestión de antojos
│   ├── progress_analytics/      # Análisis y estadísticas
│   ├── quit_timer/              # Cronómetro de abandono
│   └── settings_profile/        # Configuración y perfil
├── routes/
│   └── app_routes.dart          # Definición de rutas
├── services/
│   └── local_data_service.dart  # Gestión de datos con SharedPreferences
├── theme/
│   └── app_theme.dart           # Tema global (colores, tipografía)
├── widgets/
│   ├── custom_error_widget.dart # Widget de error personalizado
│   ├── custom_icon_widget.dart  # Wrapper de iconos
│   └── custom_image_widget.dart # Loader de imágenes (SVG, assets, web)
└── main.dart                    # Entry point
```

## 🎨 Temas y Estilos

### Paleta de Colores (Calm Authority Design)

- **Primary**: `#2E7D5A` (Verde bosque profundo) 
- **Secondary**: `#F4F7F5` (Fondo salvia suave)
- **Accent**: `#E8B86D` (Oro cálido para logros)
- **Error**: `#C5524A` (Rojo atenuado)
- **Success**: `#4A8B6B` (Verde armonioso)

### Tipografía

Utiliza **Google Fonts - Inter** para una credibilidad médica y legibilidad óptima.

## 📱 Responsive Design

La app usa **Sizer** para un diseño completamente responsivo:

```dart
// Ejemplo de dimensionamiento responsivo
Container(
  width: 50.w,  // 50% del ancho de pantalla
  height: 20.h, // 20% del alto de pantalla
)
```

## 🔒 Datos Locales y Privacidad

Los datos se almacenan localmente usando **SharedPreferences**:

```dart
// LocalDataService maneja:
- Perfil de usuario
- Historial de fumar
- Historial de antojos
- Logros desbloqueados
- Configuración de la app
- Exportación a JSON/CSV
```

**Nota**: No hay sincronización con servidores ni análisis remotos.

## 📊 Exportación de Datos

Puedes exportar tus datos en dos formatos:

### JSON
```json
{
  "profile": { ... },
  "smokingData": [ ... ],
  "cravingHistory": [ ... ],
  "achievements": [ ... ],
  "statistics": { ... }
}
```

### CSV
Para importar a Excel o Google Sheets con historial detallado.

## 🧪 Validación de Código

### Análisis Estático

```bash
flutter analyze
```

Todos los análisis deben pasar sin errores.

### Linting

La configuración de lints sigue **flutter_lints: ^5.0.0** con reglas estrictas.

## 🔧 Build para Producción

### Android

```bash
flutter build apk --release
```

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ipa --release
```

## 🐛 Solución de Problemas

### Error: "Unable to determine engine version"

Si ves este error relacionado con git:

```bash
git config --global --add safe.directory C:/tools/flutter
```

### Packages Outdated

Para actualizar dependencias:

```bash
flutter pub upgrade
```

Para ver versiones disponibles:

```bash
flutter pub outdated
```

### Caché de Build

Limpia el caché de build en caso de errores persistentes:

```bash
flutter clean
flutter pub get
```

## 📝 Configuración del Proyecto

### pubspec.yaml - Dependencias Críticas

```yaml
# No modificar o remover
flutter:                         # SDK de Flutter
flutter_lints: ^5.0.0          # Linting
flutter_test:                   # Testing

# UI Responsivo
sizer: ^2.0.15                 # Responsive design
flutter_svg: ^2.0.9            # Soporte SVG
google_fonts: ^6.1.0           # Tipografía

# Datos y Storage
shared_preferences: ^2.2.2     # Almacenamiento local
```

### Assets

El proyecto usa dos directorios:
- `assets/` - Recursos generales
- `assets/images/` - Imágenes y SVGs

**Regla crítica**: No agregar nuevos directorios de assets (`assets/svg/`, `assets/icons/`, etc.).

## 🚀 Próximos Pasos

1. **Personalización**: Ajusta colores, textos e idiomas según tus necesidades
2. **Integración de API**: Si deseas sincronización en la nube, implementa la capa de red
3. **Push Notifications**: Agrega soporte para notificaciones usando `firebase_messaging`
4. **Análisis Avanzado**: Integra `firebase_analytics` para telemetría local
5. **Temas Dinámicos**: Permite que usuarios personalicen colores

## 📖 Documentación Adicional

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Language](https://dart.dev)
- [Material Design 3](https://m3.material.io)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Crea una rama para tu feature: `git checkout -b feature/nueva-funcionalidad`
2. Escribe código limpio siguiendo las convenciones de Dart
3. Corre `flutter analyze` para validar
4. Envía un pull request con descripción clara

## 📄 Licencia

Este proyecto está bajo licencia MIT. Consulta `LICENSE` para más detalles.

## ✨ Agradecimientos

- **Diseño**: Inspirado en aplicaciones de bienestar y therapeutic minimalism
- **Flutter Team**: Por el excelente framework
- **Community**: Por las librerías y herramientas

