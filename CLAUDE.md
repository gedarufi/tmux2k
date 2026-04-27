# tmux2k-gedarufi

Personal fork of [2kabhishek/tmux2k](https://github.com/2kabhishek/tmux2k) with specific customizations for gedarufi's environment.

## Purpose

Preserve changes made on top of the original tmux2k plugin so they are not lost when updating via tpm. The plugin is referenced from `~/.config/tmux/tmux.conf`.

## Modified files from upstream

### `plugins/path.sh`
Rewritten with compact agnoster style:
- Replaces `$HOME` with home icon ``
- Each intermediate segment is represented as `  ` (folder icon, no name)
- Only the last segment (current directory) shows its full name
- Example: `~/Documents/coding/synkron/code` → ` ~    code`

### `plugins/session.sh`
- Shows OS icon (` ` on macOS, `` on Linux)
- If the session name is numeric, shows only the icon (suppresses the number)

### `plugins/cpu.sh`
- Removed `normalize_padding` in `get_cpu_usage()` to eliminate padding spaces around the percentage
- Compact output: `13%` instead of ` 13% `

### `plugins/gpu.sh`
- Removed `normalize_padding` in `get_gpu()` for compact output

### `plugins/ram.sh`
- Removed `normalize_padding` in `get_percent()` for compact output

## tmux.conf configuration

The plugin is loaded via tpm pointing to this fork:
```
set -g @plugin 'gedarufi/tmux2k'
```

## Colors (Tokyo Night Storm)

| tmux2k variable    | Hex       |
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

## Current layout

```
[Session][Path][Git][● win1][● win2]...        [Battery][CPU][GPU][RAM][Langs][Time]
```

- Left plugins: `session path git`
- Right plugins: `battery cpu gpu ram langs time`
- Window list: rounded pills (U+E0B6 / U+E0B4), left-aligned
- Active window: blue pill (`blue` on `bg_main`)
- Inactive window: gray pill (`dark-gray` on `bg_main`)
