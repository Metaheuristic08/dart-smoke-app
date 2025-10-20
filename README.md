# SmokeTracker - Flutter App

Aplicación Flutter para seguimiento de abandono del tabaco y gestión de antojos, con enfoque offline-first y diseño terapéutico minimalista.

## � Documentación

- Inicio rápido: docs/getting-started.md
- Setup y troubleshooting: docs/setup-troubleshooting.md
- Build Android (APK/AppBundle): docs/build-android-apk.md
- Estado del proyecto: docs/project-status.md
- Notas de versión: docs/release-notes.md

## ⚙️ Requisitos

- Flutter SDK 3.6.0+
- Dart 3.6.0+
- Android SDK (Android) / Xcode (iOS, opcional)

Comprueba tu entorno:

```powershell
flutter doctor
```

## 🚀 Ejecutar

```powershell
cd c:\Users\toe\Desktop\dartOficial
flutter pub get
flutter run
```

Opcional:

```powershell
flutter run --dart-define-from-file=env.json   # Variables
flutter run -d <device-id>                    # Dispositivo específico
```

## 🧱 Estructura (resumen)

```
lib/
├─ core/                # Núcleo y utilidades
├─ presentation/        # Pantallas + widgets
├─ routes/              # Rutas
├─ services/            # Persistencia local
├─ theme/               # Tema global
└─ main.dart            # Entry point
```

## 📦 Build

- Android APK/AppBundle: ver docs/build-android-apk.md

## 🔒 Datos y privacidad

Datos locales con SharedPreferences (perfil, historial, logros, ajustes). No se envían datos a servidores.

## 🤝 Contribuir

1) Crea rama: `git checkout -b feature/mi-cambio`
2) Ejecuta `flutter analyze` antes de subir
3) Abre PR con descripción clara

## 📄 Licencia

MIT

