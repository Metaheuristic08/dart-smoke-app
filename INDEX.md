# 📑 ÍNDICE DE DOCUMENTACIÓN - SMOKETRACKER

Bienvenido al proyecto **SmokeTracker**. Aquí encontrarás toda la información necesaria para ejecutar y comprender el proyecto.

---

## 🚀 INICIO RÁPIDO (¡COMIENZA AQUÍ!)

**⏱️ Tiempo requerido: 2 minutos**

1. Abre PowerShell/Terminal
2. Navega al proyecto:
   ```bash
   cd c:\Users\toe\Desktop\dartOficial
   ```
3. Ejecuta:
   ```bash
   flutter run
   ```

¡Listo! La app se abrirá en tu emulador o dispositivo.

**Archivo de referencia: [QUICKSTART.md](QUICKSTART.md)**

---

## 📚 DOCUMENTACIÓN POR NIVEL

## 🎁 NUEVO - COMPILAR APK

**¿Quieres hacer un APK para compartir o subir a Play Store?**

👉 Lee: **[APK_BUILD_GUIDE.md](APK_BUILD_GUIDE.md)** (10 min)

Ejecuta el script automático:
```bash
.\BUILD_APK_NO_DEVMODE.ps1 -mode release  # ⭐ SIN DEVELOPER MODE
```

o

```bash
.\BUILD_APK.ps1 -mode release  # Con Dev Mode (opcional)
```

---

## 🔧 ERROR DE SYMLINK EN WINDOWS?

Si ves: "Building with plugins requires symlink support"

👉 Lee: **[SYMLINK_SOLUTION.md](SYMLINK_SOLUTION.md)** (2 min)

La solución inmediata:
```bash
.\BUILD_APK_NO_DEVMODE.ps1 -mode release
```

---

### 🟢 PRINCIPIANTE (Sin experiencia con Flutter)

Comienza por aquí:

1. **[STATUS.txt](STATUS.txt)** (3 min)
   - Resumen ejecutivo del proyecto
   - Lista de cambios realizados
   - Verificaciones finales

2. **[README.md](README.md)** (10 min)
   - Descripción general del proyecto
   - Guía de instalación paso a paso
   - Estructura del proyecto
   - Características principales

3. **[QUICKSTART.md](QUICKSTART.md)** (2 min)
   - Inicio en 3 pasos
   - Comandos esenciales
   - Solución rápida de problemas

### 🟡 INTERMEDIO (Desarrollador Flutter básico)

Profundiza en detalles:

1. **[SETUP.md](SETUP.md)** (20 min)
   - Configuración detallada
   - Alternativas de ejecución
   - Troubleshooting exhaustivo
   - Variables de entorno
   - Build para producción

2. **[PROJECT_STATUS.md](PROJECT_STATUS.md)** (15 min)
   - Estado técnico completo
   - Cambios realizados
   - Estructura de datos
   - Dependencias críticas
   - Próximos pasos sugeridos

### 🔴 AVANZADO (Desarrollador Flutter experimentado)

Información técnica:

- **project.yaml** → Configuración del proyecto
- **pubspec.yaml** → Dependencias y versiones
- **lib/core/app_export.dart** → Exportaciones globales
- **lib/theme/app_theme.dart** → Sistema de temas completo

---

## 📋 ARCHIVOS DE REFERENCIA

| Archivo | Tamaño | Propósito |
|---------|--------|----------|
| INDEX.md | 6 KB | Índice de documentación |
| QUICKSTART.md | 5 KB | Inicio rápido (3 pasos) |
| STATUS.txt | 11 KB | Resumen ejecutivo |
| README.md | 7 KB | Documentación general |
| SETUP.md | 5 KB | Configuración y troubleshooting |
| PROJECT_STATUS.md | 9 KB | Estado técnico detallado |
| **APK_BUILD_GUIDE.md** | **12 KB** | **📦 CÓMO COMPILAR APK** |
| START.ps1 | 7 KB | Script de inicio |
| BUILD_APK.ps1 | 8 KB | Script automático de compilación |

---

## 🎯 RUTAS DE NAVEGACIÓN RECOMENDADAS

### Si quieres ejecutar ahora:
```
STATUS.txt (2 min) → QUICKSTART.md (2 min) → flutter run
```

### Si quieres entender la estructura:
```
README.md (10 min) → PROJECT_STATUS.md (15 min) → Revisar código
```

### Si tienes problemas:
```
SETUP.md → Consultar sección de troubleshooting
```

### Si quieres saber todo:
```
STATUS.txt → README.md → SETUP.md → PROJECT_STATUS.md
```

---

## 🔧 COMANDOS ESENCIALES

```bash
# Ejecutar la app
flutter run

# Ejecutar con verbose (ver detalles)
flutter run -v

# Verificar salud del ambiente
flutter doctor

# Instalar dependencias
flutter pub get

# Analizar código
flutter analyze

# Limpiar caché
flutter clean

# Ver dispositivos disponibles
flutter devices
```

---

## 📱 PANTALLAS DISPONIBLES

1. **Dashboard Home** (`/`)
   - Panel de control principal
   - Métricas en tiempo real
   - Acceso rápido a funciones

2. **Progress Analytics** (`/progress-analytics`)
   - Gráficos de progreso
   - Análisis detallados
   - Filtros por fecha

3. **Quit Timer** (`/quit-timer`)
   - Cronómetro de abandono
   - Hitos de salud
   - Compartir logros

4. **Craving Management** (`/craving-management`)
   - Técnicas de manejo
   - Apoyo de emergencia
   - Historial de antojos

5. **Settings Profile** (`/settings-profile`)
   - Perfil de usuario
   - Configuración
   - Exportar datos

6. **Splash Screen** (`/splash-screen`)
   - Pantalla de carga
   - Inicialización de datos

---

## ❓ PREGUNTAS FRECUENTES

**P: ¿Cuánto tiempo toma la primera ejecución?**
R: 2-3 minutos (compilación inicial). Las siguientes son instantáneas.

**P: ¿Necesito internet?**
R: No, todo funciona localmente sin conexión.

**P: ¿Dónde se guardan mis datos?**
R: En SharedPreferences del dispositivo (almacenamiento local).

**P: ¿Puedo exportar mis datos?**
R: Sí, en formato JSON o CSV desde Settings.

**P: ¿Qué versión de Flutter necesito?**
R: Flutter 3.6.0 o superior.

---

## 🆘 NECESITO AYUDA

### Problema: La app no abre
1. Ejecuta `flutter clean`
2. Ejecuta `flutter pub get`
3. Vuelve a ejecutar `flutter run`

### Problema: Error de Gradle
Consulta la sección de troubleshooting en [SETUP.md](SETUP.md)

### Problema: No encuentro en documentación
1. Revisa [PROJECT_STATUS.md](PROJECT_STATUS.md) para detalles técnicos
2. Ejecuta `flutter doctor` para revisar tu ambiente
3. Consulta [README.md](README.md) para información general

---

## 📊 ESTADÍSTICAS DEL PROYECTO

- **Archivos Dart**: 42
- **Líneas de código**: 5000+
- **Dependencias**: 117
- **Pantallas**: 6 funcionales
- **Widgets**: 27+ reutilizables
- **Errores de análisis**: 0 ✅
- **Warnings**: 0 ✅

---

## 🎯 CHECKLIST ANTES DE EMPEZAR

- [ ] Flutter instalado (`flutter --version`)
- [ ] Dart instalado (`dart --version`)
- [ ] Emulador o dispositivo disponible (`flutter devices`)
- [ ] Has leído [QUICKSTART.md](QUICKSTART.md)
- [ ] Ejecutaste `flutter pub get`

---

## 📝 PRÓXIMOS PASOS DESPUÉS DE EJECUTAR

1. ✅ Navega entre las 6 pantallas principales
2. ✅ Registra algunos datos (cigarrillos, antojos)
3. ✅ Revisa el análisis y gráficos
4. ✅ Prueba la exportación de datos
5. ✅ Personaliza en Settings

---

## 🎓 PARA DESARROLLADORES

Si quieres extender el proyecto:

1. **Entender la estructura**: Lee [PROJECT_STATUS.md](PROJECT_STATUS.md)
2. **Revisar el tema**: `lib/theme/app_theme.dart`
3. **Ver servicios**: `lib/services/local_data_service.dart`
4. **Explorar widgets**: `lib/presentation/*/widgets/`
5. **Modificar rutas**: `lib/routes/app_routes.dart`

---

## 📄 INFORMACIÓN FINAL

- **Versión**: 1.0.0
- **Estado**: ✅ Listo para producción
- **Última actualización**: 16 de Octubre de 2025
- **Licencia**: MIT

---

## 🚭 ¡A COMENZAR!

**Ejecuta ahora:**
```bash
flutter run
```

¡Disfruta de SmokeTracker! 🎉

---

**¿Necesitas ayuda?** → Consulta [SETUP.md](SETUP.md) o [README.md](README.md)
