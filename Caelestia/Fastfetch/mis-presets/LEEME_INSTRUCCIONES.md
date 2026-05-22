# 🎨 Sistema Dinámico de Fastfetch — Instrucciones de Uso

Este directorio (`mis-presets`) contiene un sistema autocontenido para hacer tu fastfetch dinámico en **Caelestia/Hyprland**.

Es compatible tanto con terminales **Kitty** como **Foot**, mezclando logos PNG y arte ASCII (`.txt`).

Ahora soporta **múltiples presets** (configs `.jsonc`) que puedes alternar con un solo comando.

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
| `preset-f1.jsonc` | ⚙️ Preset original | El primer preset de Fastfetch. Define qué información se muestra (OS, CPU, GPU, RAM, etc.), el diseño visual y de dónde se lee el logo. |
| `caelestia-modify.jsonc` | ⚙️ Preset Caelestia Box | Segundo preset con diseño de recuadro con bordes Unicode (╭╮╰╯│). Muestra info compacta con iconos Nerd Font. |
| `alterfetch.sh` | 🔄 Lanzador multi-preset | Script que randomiza el logo y ejecuta fastfetch con el preset elegido. Acepta argumentos: nombre, `-pN`, `--list`, `-h`. |
| `randomize.sh` | 🎲 Motor de rotación | Lee el modo actual (`random` o fijo), selecciona un logo de la carpeta `logos/`, y crea un symlink (`current`). **No muestra nada**, solo prepara el logo. |
| `set_mode.sh` | 🎯 Selector de modo (logos) | Cambia entre modo **aleatorio** (`random`) y modo **fijo** (un logo específico). Guarda tu elección en `mode.txt`. |
| `set_preset.sh` | 🎛️ Selector de preset | Cambia entre presets (`.jsonc`). Guarda tu elección en `preset.txt` para que persista. |
| `greeting_example.fish` | 🐟 Ejemplo de greeting | Plantilla para integrar con Fish shell. Cópialo a `~/.config/fish/functions/fish_greeting.fish`. |
| `LEEME_INSTRUCCIONES.md` | 📖 Este archivo | Documentación completa con instrucciones de instalación y uso. |

### 📁 ¿Y la carpeta `presets/`?

| Elemento | Descripción |
|---|---|
| `presets/*.jsonc` | Los presets de fastfetch. Puede haber tantos como quieras. |
| `presets/logos/` | Carpeta donde van todos los logos: imágenes **PNG/JPG** y archivos de arte **ASCII** (`.txt`). |
| `presets/current` | Symlink que apunta al logo activo. Lo genera `randomize.sh` automáticamente. **No lo toques manualmente.** |
| `presets/mode.txt` | Guarda el modo de logos (`random` o el nombre del archivo fijo). Lo gestiona `set_mode.sh`. |
| `presets/preset.txt` | Guarda el preset activo (ej: `preset-f1`). Lo gestiona `set_preset.sh` y `alterfetch.sh`. |

### 💡 ¿Cómo se relacionan entre sí?

```
Terminal se abre
    │
    ▼
fish_greeting.fish  ──►  randomize.sh  ──►  Elige logo ──► Crea symlink "current"
    │                                                              │
    ▼                                                              │
Lee preset.txt  ──►  fastfetch --config <preset>.jsonc  ◄──────────┘
    │                         (el .jsonc lee "current")
    ▼
Muestra tu sistema con el logo + preset elegidos
```

### 🤔 Preguntas rápidas

**¿Puedo usar esto sin Fish shell?**
> Sí. Puedes ejecutar `./alterfetch.sh` directamente desde Bash/Zsh. Solo el greeting automático requiere Fish.

**¿Qué pasa si borro `current`, `mode.txt` o `preset.txt`?**
> Nada grave. Se recrean solos la próxima vez que ejecutes los scripts.

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

> Esto randomizará un logo y mostrará el fastfetch con el último preset usado.

Para probar un preset específico:

```bash
./alterfetch.sh -p1      # Primer preset
./alterfetch.sh -p2      # Segundo preset
./alterfetch.sh --list   # Ver todos los presets disponibles
```

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

    # Leer el preset activo
    set -l preset "preset-f1"
    if test -f presets/preset.txt
        set preset (string trim (cat presets/preset.txt))
    end

    fastfetch --config "presets/$preset.jsonc"
    cd ~
end
```

---

## ⚡ 4. Comandos Manuales Globales

Para poder usar los comandos desde **cualquier lugar** sin entrar a la carpeta, crea funciones en Fish:

### alterfetch (lanzar fastfetch con preset)

```bash
echo 'function alterfetch; bash ~/.local/share/caelestia/fastfetch/mis-presets/alterfetch.sh $argv; end' > ~/.config/fish/functions/alterfetch.fish
```

### Uso de alterfetch

| Comando | Descripción |
|---|---|
| `alterfetch` | Logo random + último preset usado |
| `alterfetch -p1` | Logo random + primer preset (atajo rápido) |
| `alterfetch -p2` | Logo random + segundo preset |
| `alterfetch caelestia-modify` | Logo random + preset por nombre |
| `alterfetch --list` | Lista presets con su número `-pN` |
| `alterfetch -h` | Muestra la ayuda |

### Modos de operación de logos (dentro de `mis-presets/`)

| Comando | Descripción |
|---|---|
| `./set_mode.sh random` | Cambia de imagen automáticamente cada vez *(modo por defecto)* |
| `./set_mode.sh [archivo]` | Fija un logo permanente. Ejemplo: `./set_mode.sh 1.png` |
| `./set_mode.sh -h` | Muestra la ayuda |

### Cambiar de preset (dentro de `mis-presets/`)

| Comando | Descripción |
|---|---|
| `./set_preset.sh` | Muestra el preset actual y la lista |
| `./set_preset.sh -p1` | Fija el primer preset |
| `./set_preset.sh caelestia-modify` | Fija un preset por nombre |
| `./set_preset.sh -h` | Muestra la ayuda |

---

## 🖼️ 5. Cómo Agregar Más Logos

Simplemente arroja tus archivos **PNG**, **JPG** o archivos de texto (`.txt`) con arte ASCII dentro de la carpeta:

```
mis-presets/presets/logos/
```

El script los reconocerá y los usará automáticamente.

---

## 🛠️ 6. Cómo Crear Tus Propios Presets

¿Quieres agregar tu propia config de fastfetch al sistema? Sigue estas reglas para que funcione sin problemas:

### Regla de Oro: `"source": "presets/current"`

Toda config `.jsonc` que agregues **debe** tener esta línea en su sección de logo:

```jsonc
"logo": {
    "source": "presets/current",
    "type": "auto",
    // ... el resto de tus opciones de logo
}
```

Esto es lo que conecta tu config con el sistema de logos aleatorios. El symlink `current` se actualiza automáticamente cada vez que abres una terminal.

### Paso a paso

1. **Consigue tu config `.jsonc`** — puede ser una que descargaste, copiaste de internet, o creaste desde cero.

2. **Modifica SOLO la sección `"logo"`** — reemplaza la línea `"source"` con `"presets/current"`:

   ```jsonc
   // ❌ ANTES (ruta fija o builtin)
   "logo": {
       "source": "/ruta/a/mi/imagen.png",
       "source": "arch",
   }

   // ✅ DESPUÉS (compatible con el sistema)
   "logo": {
       "source": "presets/current",
       "type": "auto",
       "width": 20,
       "height": 12,
       "preserveAspectRatio": true
   }
   ```

3. **No toques nada más** — los módulos, colores, separadores, bordes... todo eso es el diseño de tu config. Déjalo tal cual.

4. **Copia el archivo a `presets/`**:

   ```bash
   cp mi-nueva-config.jsonc ~/.local/share/caelestia/fastfetch/mis-presets/presets/
   ```

5. **¡Listo!** Ya puedes usarla:

   ```bash
   alterfetch mi-nueva-config
   # o con atajo:
   alterfetch --list    # ver el número asignado
   alterfetch -p3       # si es el tercero
   ```

### ⚠️ Errores comunes a evitar

| ❌ Error | ✅ Corrección |
|---|---|
| Poner una ruta absoluta en `source` | Usar siempre `"presets/current"` |
| Borrar la sección `logo` completa | Mantener el bloque `logo` con `source: presets/current` |
| Poner `"logo": null` | Cambiar a un bloque `logo` completo |
| Renombrar el archivo sin extensión `.jsonc` | Siempre usar extensión `.jsonc` |

### 💡 Tips de diseño

- **Alineación fija**: Si tu config usa bordes (como `│`), usa el formato `{valor>22}` para alinear los valores a un ancho fijo. Así las líneas del borde quedan rectas.
- **Ancho del logo**: Ajusta `"width"` y `"height"` para que el logo no se solape con tu diseño. Valores recomendados: width 18-27, height 10-14.
- **Prueba primero**: Siempre prueba tu config con `alterfetch nombre-de-tu-config` antes de fijarla como preset principal.
