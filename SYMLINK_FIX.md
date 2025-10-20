# ⚡ RESPUESTA RÁPIDA: ERROR DE SYMLINK

## Tu Error

```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```

## ✅ La Solución (1 Comando)

```powershell
.\BUILD_APK_NO_DEVMODE.ps1 -mode release
```

**¡Eso es todo!** El script compilará tu APK sin problemas.

---

## ⏱️ Tiempo

- **Primera compilación**: 10-15 minutos
- **Compilaciones futuras**: ~5 minutos

---

## 📍 Tu APK Estará En

```
c:\Users\toe\Desktop\dartOficial\build\app\outputs\flutter-apk\app-release.apk
```

---

## 📚 Si Necesitas Más Info

- Guía completa: [SYMLINK_SOLUTION.md](SYMLINK_SOLUTION.md)
- Build guide: [APK_BUILD_GUIDE.md](APK_BUILD_GUIDE.md)

---

## 🚀 ¡A Compilar!

```powershell
cd c:\Users\toe\Desktop\dartOficial
.\BUILD_APK_NO_DEVMODE.ps1 -mode release
```

¡Listo! 🎉
