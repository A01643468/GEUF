#!/bin/bash
# Script para copiar los archivos de cada integrante a flutter_app/lib/

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$ROOT/flutter_app/lib"

echo "Ensamblando proyecto en $DEST..."

# Limpiar (excepto .gitkeep)
find "$DEST" -type f ! -name '.gitkeep' -delete

# Copiar archivos del integrante 2 (comunicacion)
cp "$ROOT/integrante2_comunicacion/data_source.dart" "$DEST/"
cp "$ROOT/integrante2_comunicacion/demo_source.dart" "$DEST/"
cp "$ROOT/integrante2_comunicacion/bluetooth_source.dart" "$DEST/"

# Copiar archivos del integrante 3 (UI)
cp "$ROOT/integrante3_ui/main.dart" "$DEST/"
cp "$ROOT/integrante3_ui/home_screen.dart" "$DEST/"
cp "$ROOT/integrante3_ui/profile_screen.dart" "$DEST/"

# Copiar archivos del integrante 4 (logica)
cp "$ROOT/integrante4_logica/recommendation.dart" "$DEST/"

echo "Listo! Ahora puedes correr:"
echo "  cd flutter_app && flutter pub get && flutter run"
