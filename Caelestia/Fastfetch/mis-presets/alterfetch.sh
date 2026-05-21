#!/bin/bash

# Este script permite cambiar manualmente el logo/colores de fastfetch
# Puedes poner un alias para esto en tu .bashrc o .zshrc o config.fish

# Ubicacion del randomize.sh
DIR="$(dirname "$(realpath "$0")")"

# 1. Randomizar y aplicar colores
bash "$DIR/randomize.sh"

# 2. Entrar a la carpeta para que las rutas relativas funcionen
cd "$DIR"

# 3. Mostrar el fastfetch inmediatamente con los nuevos ajustes
fastfetch --config "presets/main.jsonc"
