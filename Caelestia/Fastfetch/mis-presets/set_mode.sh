#!/bin/bash

BASE_DIR="$(dirname "$(realpath "$0")")/presets"
MODE_FILE="$BASE_DIR/mode.txt"

if [ -z "$1" ]; then
    echo "Uso: ./set_mode.sh [random | archivo_fijo]"
    echo "Ejemplos:"
    echo "  ./set_mode.sh random     (Pone el modo en aleatorio)"
    echo "  ./set_mode.sh 1.png      (Fija el logo a 1.png)"
    echo "  ./set_mode.sh arch.txt   (Fija el logo al archivo ASCII)"
    
    # Mostrar el modo actual
    if [ -f "$MODE_FILE" ]; then
        echo -e "\nModo actual: $(cat "$MODE_FILE")"
    else
        echo -e "\nModo actual: random (por defecto)"
    fi
    exit 0
fi

MODE="$1"

if [ "$MODE" != "random" ]; then
    if [ ! -f "$BASE_DIR/logos/$MODE" ]; then
        echo "Error: El archivo '$MODE' no existe en $BASE_DIR/logos/"
        echo "Archivos disponibles:"
        ls -1 "$BASE_DIR/logos/"
        exit 1
    fi
fi

# Guardar el modo
echo "$MODE" > "$MODE_FILE"
echo "Modo cambiado a: $MODE"

# Aplicar el cambio inmediatamente
"$(dirname "$(realpath "$0")")/alterfetch.sh"
