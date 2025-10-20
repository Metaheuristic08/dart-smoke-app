# 🔧 SOLUCIÓN: ERROR DE SYMLINK EN WINDOWS

## El Problema

```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```

## ✅ 3 SOLUCIONES (Elige una)

---

## SOLUCIÓN 1: Habilitar Developer Mode (RECOMENDADO)

### Opción A: Automática (Rápida)
```powershell
start ms-settings:developers
```

1. Se abre Settings
2. Activa "Developer Mode"
3. Espera 1 minuto a que se instale
4. Reinicia PowerShell
5. Vuelve a ejecutar: `.\BUILD_APK.ps1 -mode release`

**Tiempo**: 2 minutos

### Opción B: Manual
1. Abre Settings (Windows + I)
2. Ve a: Update & Security → For developers
3. Activa "Developer Mode"
4. Espera a que se instale
5. Reinicia PowerShell

---

## SOLUCIÓN 2: Compilar SIN Symlinks (Si no quieres Developer Mode)

Esta opción salta el paso de symlinks:

```bash
flutter build apk --debug --no-tree-shake-icons
```

O para release:

```bash
flutter build apk --release --no-tree-shake-icons
```

**Ventaja**: No necesitas Developer Mode  
**Desventaja**: APK un poco más grande

---

## SOLUCIÓN 3: Usar WSL 2 (Windows Subsystem for Linux)

Si tienes WSL 2 instalado:

```bash
# Desde WSL 2
cd /mnt/c/Users/toe/Desktop/dartOficial
flutter build apk --release
```

**Ventaja**: Funciona sin symlinks  
**Desventaja**: Requiere WSL 2 instalado

---

## 🚀 LA FORMA MÁS RÁPIDA AHORA

### OPCIÓN A: Con Developer Mode (Recomendado)

```powershell
# 1. Habilita Developer Mode
start ms-settings:developers

# 2. Activa el toggle "Developer Mode"

# 3. Espera 1-2 minutos

# 4. Reinicia PowerShell

# 5. Luego ejecuta:
.\BUILD_APK.ps1 -mode release
```

**Tiempo total**: ~5 minutos

### OPCIÓN B: Sin Developer Mode

```powershell
# Ejecuta directamente sin Developer Mode:
flutter build apk --debug --no-tree-shake-icons
```

**Tiempo total**: ~10 minutos de compilación

---

## 📊 COMPARATIVA DE SOLUCIONES

| Solución | Tiempo Setup | Facilidad | Requisitos |
|----------|---|---|---|
| Developer Mode | 2 min | Muy fácil | Windows Settings |
| --no-tree-shake-icons | 0 min | Muy fácil | Solo Flutter |
| WSL 2 | 30 min | Normal | WSL 2 instalado |

---

## ✅ RECOMENDACIÓN

**La mejor opción es HABILITAR DEVELOPER MODE:**

```powershell
# 1. Ejecuta esto:
start ms-settings:developers

# 2. Activa el toggle (arriba a la derecha)

# 3. Espera a que instale (~1 minuto)

# 4. Reinicia PowerShell

# 5. Vuelve a intentar:
.\BUILD_APK.ps1 -mode release
```

Después de esto, Flutter compilará sin problemas.

---

## 🐛 SI SIGUE FALLANDO

Prueba esto para limpiar y reintentar:

```bash
flutter clean
flutter pub get
flutter build apk --release --no-tree-shake-icons
```

---

## 📌 NOTAS IMPORTANTES

- **Developer Mode es seguro**: Solo habilita herramientas de desarrollo en Windows
- **No ralentiza tu PC**: Tiene un impacto mínimo
- **Es recomendado para desarrollo**: Muchos desarrolladores lo usan

---

## ✨ PRÓXIMO PASO

Elige una:

### ✅ OPCIÓN 1 (Recomendada - 5 min total)
```powershell
start ms-settings:developers
# Activa el toggle
# Reinicia PowerShell
.\BUILD_APK.ps1 -mode release
```

### ⚡ OPCIÓN 2 (Inmediata - sin esperar)
```bash
flutter build apk --debug --no-tree-shake-icons
```

---

**¡Elige una opción y cuéntame si funciona! 🚀**
