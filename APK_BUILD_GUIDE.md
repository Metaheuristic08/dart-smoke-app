# 📦 GUÍA COMPLETA: COMPILAR APK DE SMOKETRACKER

**Última actualización**: 16 de Octubre de 2025

---

## 🎯 ¿QUÉ ES UN APK?

Un **APK** (Android Package Kit) es el archivo ejecutable de Android. Es lo que instalas en tu teléfono/tablet desde Google Play Store o directamente.

---

## 📋 REQUISITOS PREVIOS

Antes de compilar, asegúrate de tener:

```
✅ Flutter SDK instalado
✅ Android SDK instalado
✅ Android Build Tools
✅ Java Development Kit (JDK) 11 o superior
✅ Emulador o dispositivo Android
```

**Verifica que todo esté bien:**
```bash
flutter doctor
```

Debería mostrar: `Android toolchain - develop for Android devices [✓]`

---

## 🚀 COMPILAR APK EN 5 PASOS

### PASO 1: Abre Terminal/PowerShell

```powershell
cd c:\Users\toe\Desktop\dartOficial
```

### PASO 2: Limpia Build Anterior (Recomendado)

```bash
flutter clean
flutter pub get
```

### PASO 3: OPCIÓN A - BUILD EN MODO DEBUG (Más Rápido)

```bash
flutter build apk --debug
```

**Tiempo**: 3-5 minutos  
**Tamaño**: ~50 MB  
**Uso**: Pruebas locales

### PASO 3: OPCIÓN B - BUILD EN MODO RELEASE (Recomendado para Producción)

```bash
flutter build apk --release
```

**Tiempo**: 5-10 minutos  
**Tamaño**: ~20 MB  
**Uso**: Desplegar en Google Play Store

---

## 📍 DÓNDE ENCUENTRA EL APK

Después de compilar exitosamente, el APK estará en:

**Debug:**
```
c:\Users\toe\Desktop\dartOficial\build\app\outputs\flutter-apk\app-debug.apk
```

**Release:**
```
c:\Users\toe\Desktop\dartOficial\build\app\outputs\flutter-apk\app-release.apk
```

---

## 📱 INSTALAR APK EN DISPOSITIVO

### Opción A: Instalación Automática (Recomendado)

Después del build, ejecuta:

```bash
flutter install
```

Flutter detectará el APK compilado e instalará automáticamente en tu dispositivo/emulador.

### Opción B: Instalación Manual

```bash
# Listar dispositivos disponibles
flutter devices

# Instalar en dispositivo específico
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Opción C: Copiar y Abrir Manualmente

1. Ve a la carpeta del APK
2. Copia `app-release.apk` a tu computadora/teléfono
3. Abre en tu teléfono Android
4. Acepta instalar desde fuente desconocida si es necesario

---

## ⚙️ CONFIGURACIÓN ANTES DE BUILD (Importante)

### Paso 1: Configura android/app/build.gradle

Abre: `android/app/build.gradle`

Verifica estas secciones:

```gradle
android {
    compileSdkVersion 34  // O la versión actual
    
    defaultConfig {
        applicationId "com.example.smoketracker"  // Cambiar esto
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Paso 2: Configura Firma Digital (Para Release)

Crea un archivo de configuración de firma. Ve a: `android/app/build.gradle`

Busca la sección `signingConfigs` y asegúrate de que esté configurada o agrega:

```gradle
signingConfigs {
    release {
        keyAlias "smoketracker"
        keyPassword "tu_contraseña"
        storeFile file("release.keystore")
        storePassword "tu_contraseña"
    }
}
```

**Para generar el keystore (solo una vez):**

```bash
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias smoketracker
```

Este comando:
- Genera un archivo `release.keystore` en `android/app/`
- Te pide información (País, Ciudad, Empresa, etc.)
- Usa ese keystore para firmar futuros APK

---

## 📊 TIPOS DE BUILD

### DEBUG APK
```bash
flutter build apk --debug
```
- **Tamaño**: Más grande (~50 MB)
- **Velocidad**: Más rápido de compilar
- **Uso**: Desarrollo y pruebas
- **Firma**: No requiere configuración adicional
- **Instalación**: Rápida

### RELEASE APK
```bash
flutter build apk --release
```
- **Tamaño**: Más pequeño (~20 MB)
- **Velocidad**: Más lento de compilar (optimización)
- **Uso**: Producción, Google Play Store
- **Firma**: Requiere keystore
- **Instalación**: Más segura

### SPLIT APK (Múltiples arquitecturas)
```bash
flutter build apk --split-per-abi --release
```

Genera 3 APK separados:
- `app-armeabi-v7a-release.apk` (32-bit)
- `app-arm64-v8a-release.apk` (64-bit)
- `app-x86_64-release.apk` (Emulador)

---

## 🔍 SOLUCIÓN DE PROBLEMAS

### Problema 1: "Build Gradle antiguo"

**Error:**
```
Your app is using an unsupported Gradle project
```

**Solución:**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter build apk --release
```

### Problema 2: "Java version too old"

**Error:**
```
The Java version is too old
```

**Solución:**
1. Instala Java 11 o superior
2. Verifica: `java -version`
3. Si no aparece, agrega al PATH la ruta de Java

### Problema 3: "Insufficient disk space"

**Solución:**
```bash
flutter clean
```

Esto elimina archivos temporales de build (libera ~500 MB)

### Problema 4: "SDK version not compatible"

**Solución:**
Abre `android/app/build.gradle` y actualiza:
```gradle
compileSdkVersion 34
targetSdkVersion 34
```

### Problema 5: "APK no se instala"

**Solución:**
```bash
adb uninstall com.example.smoketracker
flutter install
```

---

## 📈 COMPARATIVA: DEBUG vs RELEASE

| Característica | DEBUG | RELEASE |
|---|---|---|
| Tamaño | 50-60 MB | 15-25 MB |
| Tiempo | 3-5 min | 8-15 min |
| Optimización | No | Sí (tree-shaking, minificación) |
| Debugging | Sí | No |
| Performance | Lenta | Rápida |
| Producción | ❌ No | ✅ Sí |

---

## 🎯 GUÍA RÁPIDA: BUILD EN 3 PASOS

```bash
# Paso 1: Limpia
flutter clean

# Paso 2: Compila
flutter build apk --release

# Paso 3: Instala
flutter install
```

¡Listo! La app se instalará en tu dispositivo.

---

## 📱 INSTALAR EN MÚLTIPLES DISPOSITIVOS

```bash
# Ver dispositivos
flutter devices

# Instalar en dispositivo específico
flutter install -d <device-id>
```

---

## 🚀 SUBIR A GOOGLE PLAY STORE (Próximos pasos)

Una vez compilado el APK release, puedes subirlo a Google Play Store:

1. **Crea cuenta de Google Play Developer** (~$25 único)
2. **Genera un App Bundle** en lugar de APK:
   ```bash
   flutter build appbundle --release
   ```
3. **Sube el bundle** a Google Play Console
4. **Completa metadatos** (descripción, screenshots, etc.)
5. **Publica la app**

Esto hará que la app esté disponible en Google Play Store.

---

## 📸 VERIFICAR QUE EL APK FUNCIONA

Después de instalar:

1. Abre Settings en tu teléfono
2. Ve a Apps → SmokeTracker
3. Verifica que está instalada
4. Abre la app y prueba funcionalidades

---

## 💾 GUARDAR APK PARA DISTRIBUCIÓN

Si quieres guardar el APK compilado:

```bash
# Crear carpeta de salida
mkdir c:\Users\toe\Desktop\SmokeTracker_APK

# Copiar APK compilado
copy build\app\outputs\flutter-apk\app-release.apk c:\Users\toe\Desktop\SmokeTracker_APK\
```

Ahora puedes:
- Compartir el APK por email
- Subirlo a un servidor
- Enviarlo a testers
- Distribuirlo manualmente

---

## 📝 CHECKLIST ANTES DE BUILD FINAL

- [ ] Actualizaste `versionCode` y `versionName` en build.gradle
- [ ] Ejecutaste `flutter analyze` (0 issues)
- [ ] Ejecutaste `flutter test` si tienes tests
- [ ] Probaste la app en emulador
- [ ] Configuraste firma digital (para release)
- [ ] Tienes espacio en disco (~2 GB)
- [ ] Java está instalado (flutter doctor ok)

---

## 🎓 COMANDOS REFERENCIA

```bash
# Build básicos
flutter build apk                    # Debug automático
flutter build apk --debug            # Debug explícito
flutter build apk --release          # Release

# Build avanzados
flutter build apk --split-per-abi --release  # Múltiples arquitecturas
flutter build appbundle --release    # Para Google Play Store

# Instalar
flutter install                      # Instalar en dispositivo por defecto
flutter install -d <device-id>      # Instalar en dispositivo específico

# Utilidades
flutter devices                      # Ver dispositivos
flutter doctor                       # Revisar setup
flutter clean                        # Limpiar cache
adb uninstall <package-name>        # Desinstalar app
adb logcat                          # Ver logs del dispositivo
```

---

## 🔐 SEGURIDAD: PROTEGE TU KEYSTORE

⚠️ **IMPORTANTE**: Tu archivo `release.keystore` es como una contraseña maestra. 

**NUNCA compartas:**
- El archivo `release.keystore`
- La contraseña del keystore
- La contraseña del alias

**SIEMPRE guarda:**
- Una copia de seguridad del keystore en lugar seguro
- La contraseña en lugar seguro (gestor de contraseñas)

Si pierdes el keystore, NO PODRÁS actualizar tu app en Google Play Store.

---

## 📊 MONITOREO POST-INSTALACIÓN

Después de instalar, puedes:

```bash
# Ver logs en tiempo real
flutter logs

# Ver estado de la app
adb shell pm dump com.example.smoketracker
```

---

## ✅ RESUMEN

| Paso | Comando | Tiempo |
|------|---------|--------|
| 1. Limpia | `flutter clean` | 30 seg |
| 2. Descarga | `flutter pub get` | 1 min |
| 3. Compila | `flutter build apk --release` | 10 min |
| 4. Instala | `flutter install` | 2 min |
| **TOTAL** | | **~13 min** |

---

## 🎯 PRÓXIMOS PASOS

1. ✅ Compila tu primer APK con `flutter build apk --release`
2. 🧪 Instala y prueba en tu dispositivo
3. 📸 Toma screenshots para Google Play
4. 📝 Prepara descripción y detalles de la app
5. 🚀 (Opcional) Sube a Google Play Store

---

## 🆘 NECESITAS AYUDA

Si hay errores durante la compilación:

1. Ejecuta `flutter doctor` y arregla los problemas que muestre
2. Consulta `SETUP.md` en el proyecto (sección troubleshooting)
3. Busca el error en Google (usualmente hay solución)
4. Intenta `flutter clean && flutter pub get`

---

## 📞 REFERENCIA RÁPIDA

**BUILD DEBUG** (Rápido, para pruebas):
```bash
flutter build apk --debug && flutter install
```

**BUILD RELEASE** (Lento, para producción):
```bash
flutter build apk --release && flutter install
```

**BUILD MÚLTIPLE** (Para Google Play):
```bash
flutter build appbundle --release
```

---

**¡Listo para compilar tu APK! 🚀**

Si completaste estos pasos, tu app SmokeTracker ya está lista en tu dispositivo Android.

Disfruta distribuyendo tu aplicación. 🎉
