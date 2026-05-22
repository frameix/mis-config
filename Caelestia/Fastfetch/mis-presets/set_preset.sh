#!/bin/bash

# ══════════════════════════════════════════════════════════════
# set_preset — Cambia el preset activo de Fastfetch
#
# Uso:
#   ./set_preset.sh                     → Muestra preset actual + lista
#   ./set_preset.sh <nombre-preset>     → Fija un preset
#   ./set_preset.sh -p1, -p2, ...       → Fija un preset por número
#   ./set_preset.sh -h | --help         → Muestra esta ayuda
# ══════════════════════════════════════════════════════════════

BASE_DIR="$(dirname "$(realpath "$0")")/presets"
PRESET_FILE="$BASE_DIR/preset.txt"

# ── Función: listar presets con su número ──
list_presets() {
    echo "Presets disponibles:"
    echo ""
    local i=1
    for f in "$BASE_DIR"/*.jsonc; do
        local name
        name=$(basename "$f" .jsonc)
        local marker="  "
        if [ -f "$PRESET_FILE" ] && [ "$(cat "$PRESET_FILE" | tr -d '[:space:]')" = "$name" ]; then
            marker="▶ "
        fi
        echo "  ${marker}-p${i}  →  ${name}"
        i=$((i + 1))
    done
}

# ── Función: mostrar ayuda ──
show_help() {
    echo "set_preset — Cambia el preset activo de Fastfetch"
    echo ""
    echo "Uso:"
    echo "  ./set_preset.sh                     Muestra preset actual + lista"
    echo "  ./set_preset.sh <nombre-preset>     Fija un preset específico"
    echo "  ./set_preset.sh -p1, -p2, ...       Fija un preset por número"
    echo "  ./set_preset.sh -h | --help         Muestra esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  ./set_preset.sh preset-f1"
    echo "  ./set_preset.sh caelestia-modify"
    echo "  ./set_preset.sh -p2"
    echo ""
    echo "El preset elegido se guarda en preset.txt y se reutiliza"
    echo "por alterfetch cuando se ejecuta sin argumentos."
}

# ── Función: obtener preset por número ──
get_preset_by_number() {
    local num=$1
    local i=1
    for f in "$BASE_DIR"/*.jsonc; do
        if [ "$i" -eq "$num" ]; then
            basename "$f" .jsonc
            return 0
        fi
        i=$((i + 1))
    done
    return 1
}

# ── Sin argumentos: mostrar estado actual ──
if [ -z "$1" ]; then
    echo ""
    if [ -f "$PRESET_FILE" ]; then
        echo "Preset actual: $(cat "$PRESET_FILE" | tr -d '[:space:]')"
    else
        echo "Preset actual: (ninguno guardado)"
    fi
    echo ""
    list_presets
    echo ""
    echo "Usa: ./set_preset.sh <nombre>  o  ./set_preset.sh -pN"
    exit 0
fi

# ── Ayuda ──
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# ── Parsear argumento ──
PRESET=""

if [[ "$1" =~ ^-p([0-9]+)$ ]]; then
    NUM="${BASH_REMATCH[1]}"
    PRESET=$(get_preset_by_number "$NUM")
    if [ -z "$PRESET" ]; then
        echo "Error: No existe un preset con el número -p${NUM}"
        echo ""
        list_presets
        exit 1
    fi
else
    PRESET="$1"
fi

# ── Validar que existe ──
if [ ! -f "$BASE_DIR/${PRESET}.jsonc" ]; then
    echo "Error: El preset '${PRESET}' no existe en $BASE_DIR/"
    echo ""
    echo "Presets disponibles:"
    list_presets
    exit 1
fi

# ── Guardar el preset ──
echo "$PRESET" > "$PRESET_FILE"
echo "Preset cambiado a: $PRESET"

# ── Aplicar el cambio inmediatamente ──
"$(dirname "$(realpath "$0")")/alterfetch.sh"
