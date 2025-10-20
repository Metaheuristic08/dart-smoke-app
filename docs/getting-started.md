# 🚀 Inicio rápido

Sigue estos pasos para ejecutar SmokeTracker en tu equipo.

## 1) Abrir Terminal (PowerShell)

```powershell
cd c:\Users\toe\Desktop\dartOficial
```

## 2) Instalar dependencias

```powershell
flutter pub get
```

## 3) Ejecutar la app

```powershell
flutter run
```

La primera vez puede tardar 2-3 minutos.

---

## Alternativas de ejecución

- Con variables de entorno (archivo env.json):

```powershell
flutter run --dart-define-from-file=env.json
```

- En dispositivo específico:

```powershell
flutter devices
flutter run -d <device-id>
```

- Verbose (debug detallado):

```powershell
flutter run -v
```

---

## Verificación rápida de salud

```powershell
flutter doctor
flutter analyze
flutter pub get
```

Esperado: 0 errores, 0 warnings.

---

## Si algo falla

```powershell
flutter clean
flutter pub get
flutter run
```

Más detalles en: [Setup y troubleshooting](./setup-troubleshooting.md)
