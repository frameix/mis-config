#!/bin/bash

# Este script se ejecutará automáticamente cada vez que abras una nueva terminal
# o cuando quieras cambiar manualmente el fastfetch.

BASE_DIR="$(dirname "$(realpath "$0")")/presets"
MODE_FILE="$BASE_DIR/mode.txt"

# Modo por defecto
MODE="random"
if [ -f "$MODE_FILE" ]; then
    MODE=$(cat "$MODE_FILE")
fi

FILE=""

if [ "$MODE" != "random" ] && [ -f "$BASE_DIR/logos/$MODE" ]; then
    # Usar el archivo fijo especificado
    FILE="$BASE_DIR/logos/$MODE"
else
    # Modo aleatorio o archivo fijo no encontrado
    FILE=$(find "$BASE_DIR/logos" -type f ! -name "current*" | shuf -n 1)
fi

if [ -z "$FILE" ]; then
    echo "No se encontraron logos en $BASE_DIR/logos"
    exit 1
fi

# Crear el symlink 'current' que lee main.jsonc
ln -sf "$FILE" "$BASE_DIR/current"

