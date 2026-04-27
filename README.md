# tmux2k — gedarufi fork

Fork personal de [2kabhishek/tmux2k](https://github.com/2kabhishek/tmux2k) con customizaciones para el entorno de gedarufi.

## Instalación (tpm)

```bash
set -g @plugin 'gedarufi/tmux2k'
```

`prefix + I` para instalar.

## Cambios respecto al upstream

### `plugins/path.sh` — Estilo agnoster compacto
- `$HOME` → ícono de casa ``
- Directorios intermedios → `  ` (ícono de carpeta, sin nombre)
- Último segmento → nombre completo

```
~/Documents/coding/synkron/code  →   ~    code
```

### `plugins/session.sh` — Ícono de OS dinámico
- macOS: ` `, Linux: ``, WSL: ` WSL`
- Si el nombre de sesión es numérico, muestra solo el ícono (sin número)

### `plugins/cpu.sh` / `plugins/gpu.sh` / `plugins/ram.sh` — Output compacto
- Eliminado `normalize_padding` → `13%` en lugar de ` 13% `

### `plugins/langs.sh` — Versión del lenguaje del proyecto actual
- Detecta Node, Python, Ruby, Go, PHP según archivos en el directorio del pane

### `plugins/windows.sh` — Lista de ventanas
- Muestra ventanas con indicador activo/inactivo

## Layout actual (Tokyo Night Storm)

```
[Session][Path][Git][● win1][● win2]...        [Battery][CPU][GPU][RAM][Langs][Time]
```

```bash
set -g @tmux2k-left-plugins "session path git"
set -g @tmux2k-right-plugins "battery cpu gpu ram langs time"
```

## Paleta de colores

| Variable           | Hex       |
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

## Sincronizar con upstream

```bash
git fetch upstream
git rebase upstream/main
# resolver conflictos en los 5 archivos modificados si los hay
git push origin main
```

## Fuente

- Upstream: [2kabhishek/tmux2k](https://github.com/2kabhishek/tmux2k)
- Documentación completa de plugins y opciones: ver upstream README
