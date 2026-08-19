@echo off
title FitBack - Inicio automatico
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\start_backend.ps1"
if errorlevel 1 (
  echo.
  echo No se pudo iniciar el backend. Revisa la carpeta logs\.
  pause
  exit /b 1
)
cd /d "%~dp0mobile_app"
echo.
echo Abriendo FitBack en Chrome (puerto 3000)...
flutter run -d chrome --web-port=3000
