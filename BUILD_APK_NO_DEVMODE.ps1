#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Compilar APK SIN Developer Mode
.DESCRIPTION
    Compila APK usando --no-tree-shake-icons para evitar symlink
.USAGE
    .\BUILD_APK_NO_DEVMODE.ps1 -mode release
    .\BUILD_APK_NO_DEVMODE.ps1 -mode debug
#>

param(
    [ValidateSet("debug", "release")]
    [string]$mode = "release"
)

$ErrorActionPreference = "Stop"

Write-Host @"
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║          🚀 BUILD APK SIN DEVELOPER MODE 🚀                   ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "`n📋 CONFIGURACIÓN:" -ForegroundColor Cyan
Write-Host "   Modo: $mode" -ForegroundColor White
Write-Host "   Opción: --no-tree-shake-icons (sin symlinks)" -ForegroundColor White

Write-Host "`n⏳ INICIANDO COMPILACIÓN..." -ForegroundColor Yellow

# Paso 1: Limpiar
Write-Host "`n🧹 Paso 1/3: Limpiando build anterior..." -ForegroundColor Magenta
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al limpiar" -ForegroundColor Red
    exit 1
}

# Paso 2: Descargar dependencias
Write-Host "`n📦 Paso 2/3: Descargando dependencias..." -ForegroundColor Magenta
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al descargar dependencias" -ForegroundColor Red
    exit 1
}

# Paso 3: Compilar APK SIN SYMLINKS
Write-Host "`n🔨 Paso 3/3: Compilando APK ($mode)..." -ForegroundColor Magenta
Write-Host "   Usando: --no-tree-shake-icons (evita requisito de symlinks)" -ForegroundColor Gray
Write-Host "   (Esto puede tomar 5-15 minutos)" -ForegroundColor Gray

$buildStart = Get-Date

if ($mode -eq "debug") {
    flutter build apk --debug --no-tree-shake-icons
} else {
    flutter build apk --release --no-tree-shake-icons
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error en la compilación" -ForegroundColor Red
    Write-Host "`n💡 AYUDA:" -ForegroundColor Cyan
    Write-Host "   Si el error menciona symlinks, intenta:" -ForegroundColor White
    Write-Host "   1. Habilitar Developer Mode: start ms-settings:developers" -ForegroundColor Yellow
    Write-Host "   2. O usar: flutter build apk --release" -ForegroundColor Yellow
    Write-Host "   3. Consulta: SYMLINK_SOLUTION.md" -ForegroundColor Yellow
    exit 1
}

$buildEnd = Get-Date
$buildTime = ($buildEnd - $buildStart).TotalSeconds

Write-Host "`n✅ COMPILACIÓN EXITOSA" -ForegroundColor Green
Write-Host "   Tiempo: $([Math]::Round($buildTime, 1)) segundos" -ForegroundColor Green

# Buscar el APK compilado
$apkPath = "build/app/outputs/flutter-apk/app-$mode.apk"
if (-not (Test-Path $apkPath)) {
    Write-Host "❌ No se encontró el APK en $apkPath" -ForegroundColor Red
    exit 1
}

$apkSize = (Get-Item $apkPath).Length / 1MB
Write-Host "   Tamaño: $([Math]::Round($apkSize, 1)) MB" -ForegroundColor Green
Write-Host "   Ubicación: $(Resolve-Path $apkPath)" -ForegroundColor Green

Write-Host @"

╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║                    ✅ ¡APK COMPILADO! ✅                      ║
║                                                                ║
║  Tu APK está en:                                              ║
║  $apkPath                           ║
║                                                                ║
║  🎉 ¡COMPLETADO SIN DEVELOPER MODE!                         ║
║                                                                ║
║  📱 Para instalar en tu dispositivo:                          ║
║     flutter install                                           ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "`n¡Tu APK está listo! 🚀`n" -ForegroundColor Cyan
