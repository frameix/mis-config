# Ubicación en tu máquina Caelestia real: ~/.config/fish/functions/fish_greeting.fish

function fish_greeting
    # 1. Vamos a la carpeta para que las rutas relativas funcionen
    cd ~/.local/share/caelestia/fastfetch/mis-presets/

    # 2. Llamamos al script para rotar el logo
    bash randomize.sh

    # 3. Leer el preset activo (o usar preset-f1 por defecto)
    set -l preset "preset-f1"
    if test -f presets/preset.txt
        set preset (string trim (cat presets/preset.txt))
    end

    # 4. Verificar que el preset existe, si no usar el primero disponible
    if not test -f "presets/$preset.jsonc"
        set preset (basename (ls presets/*.jsonc | head -1) .jsonc)
    end

    # 5. Mostramos el fastfetch con el preset activo
    fastfetch --config "presets/$preset.jsonc"

    # Opcional: volvemos al directorio HOME
    cd ~
end
