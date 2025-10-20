# 🛠️ Setup y troubleshooting

Este documento consolida configuración y solución de problemas comunes.

## Estado del proyecto

- Dependencias instaladas (flutter pub get OK)
- Análisis sin errores (flutter analyze OK)
- Rutas, tema y assets verificados

## Requisitos

- Flutter SDK 3.6.0+
- Dart 3.6.0+
- Android SDK (para Android)
- Xcode (opcional, para iOS)

Verifica tu entorno:

```powershell
flutter doctor
```

---

## Comandos útiles

```powershell
flutter run              # Ejecutar la app
flutter run -v           # Verbose
flutter analyze          # Análisis estático
flutter clean            # Limpiar caché de build
flutter pub get          # Instalar dependencias
flutter devices          # Listar dispositivos
```

Durante la ejecución (en la terminal):
- r: hot reload
- R: hot restart
- q: salir

---

## Problemas comunes

### 1) Error Git Safe Directory / engine version

```powershell
git config --global --add safe.directory C:/tools/flutter
```

### 2) Caché corrupto o build inconsistente

```powershell
flutter clean
flutter pub get
flutter run
```

### 3) Gradle antiguo / toolchain Android

Para ejecutar en dispositivo normalmente basta con `flutter run`. Si persiste, crea un proyecto temporal y compara configuración Android:

```powershell
flutter create -t app temp_project
# Copia selectiva de ajustes desde temp_project/android
```

### 4) Error de symlink en Windows

Mensaje:

```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```

Soluciones:

- Habilitar Developer Mode (recomendado):

```powershell
start ms-settings:developers
```

Activa el toggle de Developer Mode, reinicia PowerShell y vuelve a intentar.

- Compilar sin symlinks (APK):

```powershell
flutter build apk --release --no-tree-shake-icons
```

- Usar WSL2 y compilar desde /mnt/c/... (opcional)

---

## Personalización

- Tema inicial: `lib/main.dart` → themeMode
- Colores: `lib/theme/app_theme.dart`
- Pantalla inicial / rutas: `lib/routes/app_routes.dart`

---

## Datos locales y privacidad

Se usa SharedPreferences para almacenar:

- user_profile, smoking_data, craving_history, achievements
- app_settings, quit_date

Exportable a JSON/CSV (según funcionalidades de la app).
