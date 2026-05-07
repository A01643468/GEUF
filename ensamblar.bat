@echo off
REM Script para copiar los archivos de cada integrante a flutter_app\lib\

set ROOT=%~dp0..
set DEST=%ROOT%\flutter_app\lib

echo Ensamblando proyecto en %DEST%...

REM Limpiar archivos .dart anteriores (sin tocar .gitkeep)
del /Q "%DEST%\*.dart" 2>nul

REM Copiar archivos del integrante 2 (comunicacion)
copy "%ROOT%\integrante2_comunicacion\data_source.dart" "%DEST%\"
copy "%ROOT%\integrante2_comunicacion\demo_source.dart" "%DEST%\"
copy "%ROOT%\integrante2_comunicacion\bluetooth_source.dart" "%DEST%\"

REM Copiar archivos del integrante 3 (UI)
copy "%ROOT%\integrante3_ui\main.dart" "%DEST%\"
copy "%ROOT%\integrante3_ui\home_screen.dart" "%DEST%\"
copy "%ROOT%\integrante3_ui\profile_screen.dart" "%DEST%\"

REM Copiar archivos del integrante 4 (logica)
copy "%ROOT%\integrante4_logica\recommendation.dart" "%DEST%\"

echo.
echo Listo! Ahora puedes correr:
echo   cd flutter_app
echo   flutter pub get
echo   flutter run
