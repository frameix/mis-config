# 🎨 Sistema Dinámico de Fastfetch — Instrucciones de Uso

Este directorio (`mis-presets`) contiene un sistema autocontenido para hacer tu fastfetch dinámico en **Caelestia/Hyprland**.

Es compatible tanto con terminales **Kitty** como **Foot**, mezclando logos PNG y arte ASCII (`.txt`).

---

## 📥 Clonar desde GitHub

Todas las configuraciones están en: **https://github.com/frameix/mis-config**

El repositorio está organizado por entorno. Dentro de `Caelestia/` encontrarás subcarpetas con configuraciones específicas (como `Fastfetch/mis-presets`).

### Clonar solo Caelestia (todas las configs de ese entorno)

```bash
git clone --no-checkout https://github.com/frameix/mis-config.git
cd mis-config
git sparse-checkout init --cone
git sparse-checkout set Caelestia
git checkout main
```

### Clonar solo Fastfetch (únicamente los presets de fastfetch)

```bash
git clone --no-checkout https://github.com/frameix/mis-config.git
cd mis-config
git sparse-checkout init --cone
git sparse-checkout set Caelestia/Fastfetch
git checkout main
```

Una vez clonado, copia `mis-presets` a su ubicación y sigue desde la **sección 1**:

```bash
cp -r mis-config/Caelestia/Fastfetch/mis-presets ~/.local/share/caelestia/fastfetch/
```

---

## ❓ Preguntas Frecuentes (FAQ)

Antes de empezar, aquí tienes un resumen rápido de **qué es cada archivo** y para qué sirve:

### 🗂️ ¿Qué archivos hay y qué hace cada uno?

| Archivo | ¿Qué es? | Descripción |
|---|---|---|
| `main.jsonc` | ⚙️ Configuración principal | Es el archivo de configuración de Fastfetch. Define **qué información se muestra** (OS, CPU, GPU, RAM, etc.), el diseño visual (bordes, colores, separadores), y de dónde se lee el logo. Fastfetch lee este archivo cada vez que se ejecuta. |
| `alterfetch.sh` | 🔄 Lanzador manual | Script que **randomiza el logo + ejecuta fastfetch** de una sola vez. Es lo que se ejecuta cuando escribes `alterfetch` en tu terminal. Ideal para rotar manualmente sin abrir una nueva pestaña. |
| `randomize.sh` | 🎲 Motor de rotación | Es el cerebro del sistema. Lee el modo actual (`random` o fijo), selecciona un logo de la carpeta `logos/`, y crea un symlink (`current`) apuntando al archivo elegido. **No muestra nada**, solo prepara el logo. |
| `set_mode.sh` | 🎯 Selector de modo | Te permite cambiar entre modo **aleatorio** (`random`) y modo **fijo** (un logo específico). Guarda tu elección en `mode.txt` para que persista. |
| `greeting_example.fish` | 🐟 Ejemplo de greeting | Plantilla de ejemplo para integrar el sistema con Fish shell. Cópialo a `~/.config/fish/functions/fish_greeting.fish` para que fastfetch se ejecute automáticamente al abrir una terminal. |
| `LEEME_INSTRUCCIONES.md` | 📖 Este archivo | Documentación completa con las instrucciones de instalación y uso. |

### 📁 ¿Y la carpeta `presets/`?

| Elemento | Descripción |
|---|---|
| `presets/main.jsonc` | La config principal de fastfetch (ver arriba). |
| `presets/logos/` | Carpeta donde van todos los logos: imágenes **PNG/JPG** y archivos de arte **ASCII** (`.txt`). |
| `presets/current` | Symlink (enlace simbólico) que apunta al logo activo. Lo genera `randomize.sh` automáticamente. **No lo toques manualmente.** |
| `presets/mode.txt` | Archivo de texto que guarda el modo actual (`random` o el nombre del archivo fijo). Lo gestiona `set_mode.sh`. |

### 💡 ¿Cómo se relacionan entre sí?

```
Terminal se abre
    │
    ▼
fish_greeting.fish  ──►  randomize.sh  ──►  Elige logo ──► Crea symlink "current"
    │                                                              │
    ▼                                                              │
fastfetch --config main.jsonc  ◄───────────────────────────────────┘
                │                         (main.jsonc lee "current")
                ▼
        Muestra tu sistema con el logo elegido
```

### 🤔 Preguntas rápidas

**¿Puedo usar esto sin Fish shell?**
> Sí. Puedes ejecutar `./alterfetch.sh` directamente desde Bash/Zsh. Solo el greeting automático requiere Fish.

**¿Qué pasa si borro `current` o `mode.txt`?**
> Nada grave. Se recrean solos la próxima vez que ejecutes `randomize.sh` o `set_mode.sh`.

**¿Necesito instalar algo extra?**
> Solo necesitas tener `fastfetch` instalado. Los scripts solo usan herramientas estándar de Linux (`bash`, `find`, `shuf`, `ln`).

**¿Funciona en Kitty y Foot?**
> Sí. Los logos PNG se renderizan nativamente en Kitty (protocolo de imágenes) y los ASCII `.txt` funcionan en ambas terminales.

---

## 📦 1. Ubicación Correcta

Lleva toda esta carpeta (`mis-presets`) y ponla en la ruta de Caelestia ~/.local/share/caelestia/fastfetch/.

Abre una terminal en la misma carpeta donde tienes `mis-presets` descargado y ejecuta:

```bash
mkdir -p ~/.local/share/caelestia/fastfetch/
cp -r mis-presets ~/.local/share/caelestia/fastfetch/
```

> Esto creará la carpeta destino si no existe y copiará todo el contenido allí.

---

## 🧪 2. Prueba Rápida (Sin instalar nada)

Si quieres probar que todo funciona antes de integrar con tu terminal, simplemente entra a la carpeta y ejecuta:

```bash
cd ~/.local/share/caelestia/fastfetch/mis-presets/
./alterfetch.sh
```

> Esto randomizará un logo y mostrará el fastfetch de inmediato. No necesitas crear funciones ni modificar archivos del sistema. Ideal para pruebas unitarias.

---

## 🐟 3. Integración con tu Terminal (El Greeting)

Para que todo se ejecute automáticamente cada vez que abras un Foot o Kitty, edita tu archivo de saludo de Fish:

**Archivo a editar:**
```
~/.config/fish/functions/fish_greeting.fish
```

Borra o comenta lo que tenga, y pega exactamente esto:

```fish
function fish_greeting
    cd ~/.local/share/caelestia/fastfetch/mis-presets/
    bash randomize.sh
    fastfetch --config presets/main.jsonc
    cd ~
end
```

---

## ⚡ 4. Comandos Manuales Globales (`alterfetch`)

Para poder rotar el fastfetch desde **cualquier lugar** (sin tener que entrar a la carpeta) con solo escribir `alterfetch`, debes crear una función en tu Fish shell.

Abre la terminal y ejecuta este comando para crear la función:

```bash
echo 'function alterfetch; bash ~/.local/share/caelestia/fastfetch/mis-presets/alterfetch.sh; end' > ~/.config/fish/functions/alterfetch.fish
```

¡Listo! A partir de ahora, donde sea que estés, abres tu Kitty y escribes `alterfetch`, y cambiará la imagen y recargará los colores.

### Modos de operación(Usar dentro de la carpeta "mis-presets")

| Comando | Descripción |
|---|---|
| `./set_mode.sh random` | Cambia de imagen/ascii automáticamente cada vez que abres una terminal *(modo por defecto)* |
| `./set_mode.sh [archivo]` | Fija un logo permanentemente para que no rote. Ejemplo: `./set_mode.sh 1.png` o `./set_mode.sh arch.txt` |

---

## 🖼️ 5. Cómo Agregar Más Logos

Simplemente arroja tus archivos **PNG**, **JPG** o archivos de texto (`.txt`) con arte ASCII dentro de la carpeta:

```
mis-presets/presets/logos/
```

El script los reconocerá y los usará automáticamente.

