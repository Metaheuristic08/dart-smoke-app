#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Script de compilación APK para SmokeTracker
.DESCRIPTION
    Automatiza el proceso de compilación y instalación de APK
.USAGE
    .\BUILD_APK.ps1 -mode release
    .\BUILD_APK.ps1 -mode debug
    .\BUILD_APK.ps1 -clean
#>

param(
    [ValidateSet("debug", "release")]
    [string]$mode = "release",
    [switch]$clean = $false,
    [switch]$install = $true,
    [switch]$noInstall = $false
)

$ErrorActionPreference = "Stop"

Write-Host @"
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║              🚀 SMOKETRACKER - APK BUILD SCRIPT 🚀            ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "`n📋 CONFIGURACIÓN:" -ForegroundColor Cyan
Write-Host "   Modo: $mode" -ForegroundColor White
Write-Host "   Limpiar antes: $clean" -ForegroundColor White
Write-Host "   Instalar después: $(if($noInstall) { 'No' } else { 'Sí' })" -ForegroundColor White

if ($noInstall) {
    $install = $false
}

Write-Host "`n⏳ INICIANDO COMPILACIÓN..." -ForegroundColor Yellow

# Paso 1: Limpiar si se solicita
if ($clean) {
    Write-Host "`n🧹 Paso 1/4: Limpiando build anterior..." -ForegroundColor Magenta
    flutter clean
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error al limpiar" -ForegroundColor Red
        exit 1
    }
}

# Paso 2: Descargar dependencias
Write-Host "`n📦 Paso 2/4: Descargando dependencias..." -ForegroundColor Magenta
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al descargar dependencias" -ForegroundColor Red
    exit 1
}

# Paso 3: Analizar código
Write-Host "`n🔍 Paso 3/4: Analizando código..." -ForegroundColor Magenta
flutter analyze
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Hay problemas en el código, pero continuando..." -ForegroundColor Yellow
}

# Paso 4: Compilar APK
Write-Host "`n🔨 Paso 4/4: Compilando APK ($mode)..." -ForegroundColor Magenta
Write-Host "   (Esto puede tomar 5-15 minutos en la primera compilación)" -ForegroundColor Gray

$buildStart = Get-Date

if ($mode -eq "debug") {
    flutter build apk --debug --no-tree-shake-icons
} else {
    flutter build apk --release --no-tree-shake-icons
}

if ($LASTEXITCODE -ne 0) {
    # Si falla, intenta con symlinks habilitados
    Write-Host "`n⚠️  Primer intento falló, intentando con opciones alternativas..." -ForegroundColor Yellow
    
    if ($mode -eq "debug") {
        flutter build apk --debug
    } else {
        flutter build apk --release
    }
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error en la compilación" -ForegroundColor Red
        Write-Host "`n💡 SOLUCIÓN:" -ForegroundColor Cyan
        Write-Host "   Necesitas habilitar Developer Mode en Windows:" -ForegroundColor White
        Write-Host "   1. Ejecuta: start ms-settings:developers" -ForegroundColor Yellow
        Write-Host "   2. Activa 'Developer Mode'" -ForegroundColor Yellow
        Write-Host "   3. Espera 1 minuto" -ForegroundColor Yellow
        Write-Host "   4. Reinicia PowerShell" -ForegroundColor Yellow
        Write-Host "   5. Intenta de nuevo" -ForegroundColor Yellow
        Write-Host "`n   O consulta: SYMLINK_SOLUTION.md" -ForegroundColor Cyan
        exit 1
    }
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

# Instalar si se solicita
if ($install) {
    Write-Host "`n📱 INSTALANDO EN DISPOSITIVO..." -ForegroundColor Magenta
    
    # Verificar que hay dispositivos disponibles
    $devices = flutter devices | Select-String "device"
    if ($devices.Count -eq 0) {
        Write-Host "⚠️  No hay dispositivos disponibles" -ForegroundColor Yellow
        Write-Host "   Ejecuta 'flutter devices' para ver dispositivos" -ForegroundColor Gray
        Write-Host "   O inicia un emulador" -ForegroundColor Gray
    } else {
        flutter install
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ APP INSTALADA CORRECTAMENTE" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Error al instalar, pero APK se compiló exitosamente" -ForegroundColor Yellow
        }
    }
}

Write-Host @"

╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║                    ✅ ¡COMPILACIÓN COMPLETADA!               ║
║                                                                ║
║  APK ubicado en: $apkPath
║                                                                ║
║  📱 Para instalar manualmente:                               ║
║     flutter install                                           ║
║                                                                ║
║  📤 Para compartir el APK:                                   ║
║     Copia el archivo a: c:\Users\toe\Desktop\SmokeTracker_APK\║
║                                                                ║
║  🚀 Para subir a Google Play Store:                          ║
║     flutter build appbundle --release                         ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "`n¡Tu APK de SmokeTracker está listo! 🎉`n" -ForegroundColor Cyan
