# 📦 Compilar APK de Android

Esta guía concentra todo lo necesario para generar el APK de SmokeTracker.

Última actualización: 16 Oct 2025

---

## Requisitos previos

- Flutter SDK instalado
- Android SDK y Build Tools
- JDK 11+
- Emulador o dispositivo Android

Verifica con:

```powershell
flutter doctor
```

---

## Opción rápida (script)

En PowerShell dentro del proyecto:

```powershell
.\BUILD_APK.ps1 -mode release
```

Si tienes error de symlink y no puedes habilitar Developer Mode, usa:

```powershell
.\BUILD_APK_NO_DEVMODE.ps1 -mode release
```

---

## Opción manual (3 comandos)

```powershell
flutter clean
flutter build apk --release
flutter install
```

APK generado en:

```
build\app\outputs\flutter-apk\app-release.apk
```

---

## Firma digital (release)

Edita `android/app/build.gradle` y configura `signingConfigs` para release. Genera un keystore (una sola vez):

```powershell
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias smoketracker
```

Protege el keystore y contraseñas; no los subas al repositorio.

---

## Variantes de build

- Debug:

```powershell
flutter build apk --debug
```

- Release optimizado:

```powershell
flutter build apk --release
```

- Split por ABI (APK más pequeños por arquitectura):

```powershell
flutter build apk --split-per-abi --release
```

- App Bundle (para Play Store):

```powershell
flutter build appbundle --release
```

---

## Solución de problemas comunes

1) Gradle/SDK desactualizado

```powershell
flutter clean; cd android; .\gradlew.bat clean; cd ..; flutter pub get; flutter build apk --release
```

2) Java version too old → instala JDK 11+ y valida `java -version`.

3) APK no se instala → desinstala previo y reinstala:

```powershell
adb uninstall com.example.smoketracker; flutter install
```

4) Error de symlink en Windows:

- Habilitar Developer Mode:

```powershell
start ms-settings:developers
```

- O compilar sin symlinks:

```powershell
flutter build apk --release --no-tree-shake-icons
```

---

## Checklist antes del build final

- versionCode / versionName actualizados
- `flutter analyze` sin issues
- Tests (si existen) pasan
- Keystore de release configurado
- Espacio en disco suficiente (~2 GB)

---

## Referencia rápida

```powershell
flutter build apk --release
flutter install
flutter build appbundle --release
flutter devices
flutter doctor
flutter clean
```
