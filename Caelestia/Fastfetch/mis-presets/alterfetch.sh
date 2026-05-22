#!/bin/bash

# ══════════════════════════════════════════════════════════════
# alterfetch — Lanzador de Fastfetch multi-preset
# Randomiza el logo y ejecuta fastfetch con el preset elegido.
#
# Uso:
#   alterfetch                    → Logo random + último preset usado
#   alterfetch <nombre-preset>    → Logo random + preset específico
#   alterfetch -p1, -p2, ...      → Logo random + preset por número
#   alterfetch --list              → Lista presets disponibles
#   alterfetch -h | --help         → Muestra esta ayuda
# ══════════════════════════════════════════════════════════════

DIR="$(dirname "$(realpath "$0")")"
PRESETS_DIR="$DIR/presets"
PRESET_FILE="$PRESETS_DIR/preset.txt"

# ── Función: listar presets con su número ──
list_presets() {
    echo "Presets disponibles:"
    echo ""
    local i=1
    for f in "$PRESETS_DIR"/*.jsonc; do
        local name
        name=$(basename "$f" .jsonc)
        # Marcar el preset activo
        local marker="  "
        if [ -f "$PRESET_FILE" ] && [ "$(cat "$PRESET_FILE" | tr -d '[:space:]')" = "$name" ]; then
            marker="▶ "
        fi
        echo "  ${marker}-p${i}  →  ${name}"
        i=$((i + 1))
    done
    echo ""
    echo "Usa: alterfetch -pN  o  alterfetch <nombre>"
}

# ── Función: mostrar ayuda ──
show_help() {
    echo "alterfetch — Lanzador de Fastfetch multi-preset"
    echo ""
    echo "Uso:"
    echo "  alterfetch                     Logo random + último preset usado"
    echo "  alterfetch <nombre-preset>     Logo random + preset específico"
    echo "  alterfetch -p1, -p2, ...       Logo random + preset por número"
    echo "  alterfetch --list              Lista presets disponibles con números"
    echo "  alterfetch -h | --help         Muestra esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  alterfetch preset-f1           Usa el preset preset-f1"
    echo "  alterfetch caelestia-modify    Usa el preset caelestia-modify"
    echo "  alterfetch -p2                 Usa el segundo preset (alfabético)"
    echo ""
    echo "El preset elegido se guarda y se reutiliza la próxima vez"
    echo "que ejecutes alterfetch sin argumentos."
}

# ── Función: obtener preset por número ──
get_preset_by_number() {
    local num=$1
    local i=1
    for f in "$PRESETS_DIR"/*.jsonc; do
        if [ "$i" -eq "$num" ]; then
            basename "$f" .jsonc
            return 0
        fi
        i=$((i + 1))
    done
    return 1
}

# ── Parsear argumentos ──
PRESET=""

if [ $# -eq 0 ]; then
    # Sin argumentos: usar el último preset guardado
    if [ -f "$PRESET_FILE" ]; then
        PRESET=$(cat "$PRESET_FILE" | tr -d '[:space:]')
    fi
elif [ "$1" = "--list" ]; then
    list_presets
    exit 0
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
elif [[ "$1" =~ ^-p([0-9]+)$ ]]; then
    # Shortcut numérico: -p1, -p2, etc.
    NUM="${BASH_REMATCH[1]}"
    PRESET=$(get_preset_by_number "$NUM")
    if [ -z "$PRESET" ]; then
        echo "Error: No existe un preset con el número -p${NUM}"
        echo ""
        list_presets
        exit 1
    fi
else
    # Argumento directo: nombre del preset
    PRESET="$1"
fi

# ── Validar que el preset existe ──
if [ -z "$PRESET" ]; then
    # Si no hay preset guardado, usar el primero disponible
    FIRST=$(ls "$PRESETS_DIR"/*.jsonc 2>/dev/null | head -1)
    if [ -z "$FIRST" ]; then
        echo "Error: No se encontraron presets (.jsonc) en $PRESETS_DIR/"
        exit 1
    fi
    PRESET=$(basename "$FIRST" .jsonc)
fi

if [ ! -f "$PRESETS_DIR/${PRESET}.jsonc" ]; then
    echo "Error: El preset '${PRESET}' no existe en $PRESETS_DIR/"
    echo ""
    list_presets
    exit 1
fi

# ── Guardar el preset como último usado ──
echo "$PRESET" > "$PRESET_FILE"

# ── Randomizar logo ──
bash "$DIR/randomize.sh"

# ── Ejecutar fastfetch ──
cd "$DIR"
fastfetch --config "presets/${PRESET}.jsonc"
