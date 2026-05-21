# Ubicación en tu máquina Caelestia real: ~/.config/fish/functions/fish_greeting.fish

function fish_greeting
    # ya que es el encargado de generar la paleta de colores dinámicamente.

    # 1. Vamos a la carpeta para que las rutas relativas funcionen
    cd ~/.local/share/caelestia/fastfetch/mis-presets/

    # 2. Llamamos al script para rotar y generar colores
    bash randomize.sh
    
    # 3. Mostramos el fastfetch
    fastfetch --config presets/main.jsonc

    # Opcional: volvemos al directorio HOME si queremos
    cd ~
end
