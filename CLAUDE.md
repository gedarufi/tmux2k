# tmux2k-gedarufi

Fork personal de [2kabhishek/tmux2k](https://github.com/2kabhishek/tmux2k) con customizaciones específicas para el entorno de gedarufi.

## Propósito

Preservar los cambios hechos sobre el plugin tmux2k original para que no se pierdan al actualizar via tpm. El plugin se referencia desde `~/.config/tmux/tmux.conf`.

## Archivos modificados respecto al original

### `plugins/path.sh`
Reescrito con estilo agnoster compacto:
- Reemplaza `$HOME` por ícono de casa ``
- Cada segmento intermedio se representa con `  ` (ícono de carpeta, sin nombre)
- Solo el último segmento (directorio actual) muestra su nombre completo
- Ejemplo: `~/Documents/coding/synkron/code` → ` ~    code`

### `plugins/session.sh`
- Muestra ícono del OS (` ` en macOS, `` en Linux)
- Si el nombre de sesión es numérico, muestra solo el ícono (suprime el número)

### `plugins/cpu.sh`
- Eliminado `normalize_padding` en `get_cpu_usage()` para quitar los espacios de relleno alrededor del porcentaje
- Output compacto: `13%` en lugar de ` 13% `

### `plugins/gpu.sh`
- Eliminado `normalize_padding` en `get_gpu()` para output compacto

### `plugins/ram.sh`
- Eliminado `normalize_padding` en `get_percent()` para output compacto

## Configuración en tmux.conf

El plugin se carga vía tpm apuntando a este fork:
```
set -g @plugin 'gedarufi/tmux2k'
```

## Colores (Tokyo Night Storm)

| Variable tmux2k    | Hex       |
|--------------------|-----------|
| `bg-main`          | `#1e1e2e` |
| `black`            | `#1a1b26` |
| `dark-gray`        | `#3f3f4f` |
| `white`            | `#c0caf5` |
| `purple`           | `#bb9af7` |
| `blue`             | `#7aa2f7` |
| `light-blue`       | `#7dcfff` |
| `green`            | `#9ece6a` |
| `light-green`      | `#73daca` |
| `yellow`           | `#e0af68` |
| `red`              | `#f7768e` |
| `orange`           | `#ff9e64` |

## Layout actual

```
[Session][Path][Git][● win1][● win2]...        [Battery][CPU][GPU][RAM][Langs][Time]
```

- Left plugins: `session path git`
- Right plugins: `battery cpu gpu ram langs time`
- Window list: rounded pills (U+E0B6 / U+E0B4), alineados a la izquierda
- Window activo: pill azul (`blue` sobre `bg_main`)
- Window inactivo: pill gris (`dark-gray` sobre `bg_main`)
