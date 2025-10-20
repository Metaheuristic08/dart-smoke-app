# ⚡ APK EN 5 MINUTOS - GUÍA RÁPIDA

## 🎯 OPCIÓN MÁS RÁPIDA

Abre PowerShell en la carpeta del proyecto y ejecuta:

```powershell
.\BUILD_APK.ps1 -mode release
```

¡Listo! El script hace todo automáticamente.

---

## 🔨 OPCIÓN MANUAL EN 3 COMANDOS

```bash
# 1. Limpiar (opcional pero recomendado)
flutter clean

# 2. Compilar APK Release
flutter build apk --release

# 3. Instalar en dispositivo/emulador
flutter install
```

**Tiempo total**: 10-15 minutos (primera vez)

---

## 📍 DÓNDE ESTÁ EL APK

Después de compilar, el APK estará en:

```
c:\Users\toe\Desktop\dartOficial\build\app\outputs\flutter-apk\app-release.apk
```

---

## 📱 INSTALAR MANUALMENTE

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

## 🐛 SI ALGO FALLA

```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## 📊 DEBUG VS RELEASE

| | DEBUG | RELEASE |
|---|---|---|
| **Comando** | `flutter build apk --debug` | `flutter build apk --release` |
| **Tamaño** | 50 MB | 20 MB |
| **Velocidad compilación** | 3 min | 10 min |
| **Performance** | Lenta | Rápida |
| **Uso** | Pruebas | Producción |

---

## 📖 DOCUMENTACIÓN COMPLETA

Para más detalles: **[APK_BUILD_GUIDE.md](APK_BUILD_GUIDE.md)**

---

## ✅ CHECKLIST RÁPIDO

- [ ] Ejecutaste `flutter doctor` (todo verde)
- [ ] Tienes emulador o dispositivo conectado
- [ ] Ejecutaste `flutter pub get`
- [ ] Ejecutaste `flutter build apk --release`
- [ ] El APK se generó exitosamente

---

## 🎉 ¡LISTO!

Tu APK está compilado y listo para:
- 📱 Instalar en tu teléfono
- 📤 Compartir con otros
- 🚀 Subir a Google Play Store

---

**Para más ayuda: Ve a [APK_BUILD_GUIDE.md](APK_BUILD_GUIDE.md)**
