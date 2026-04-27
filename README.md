# tmux2k — gedarufi fork

Personal fork of [2kabhishek/tmux2k](https://github.com/2kabhishek/tmux2k) with customizations for gedarufi's environment.

## Installation (tpm)

```bash
set -g @plugin 'gedarufi/tmux2k'
```

`prefix + I` to install.

## Changes from upstream

### `plugins/path.sh` — Compact agnoster style
- `$HOME` → home icon ``
- Intermediate directories → `  ` (folder icon, no name)
- Last segment → full name

```
~/Documents/coding/synkron/code  →   ~    code
```

### `plugins/session.sh` — Dynamic OS icon
- macOS: ` `, Linux: ``, WSL: ` WSL`
- If the session name is numeric, shows only the icon (no number)

### `plugins/cpu.sh` / `plugins/gpu.sh` / `plugins/ram.sh` — Compact output
- Removed `normalize_padding` → `13%` instead of ` 13% `

### `plugins/langs.sh` — Current project language version
- Detects Node, Python, Ruby, Go, PHP from files in the pane directory

### `plugins/windows.sh` — Window list
- Shows windows with active/inactive indicator

## Current layout (Tokyo Night Storm)

```
[Session][Path][Git][● win1][● win2]...        [Battery][CPU][GPU][RAM][Langs][Time]
```

```bash
set -g @tmux2k-left-plugins "session path git"
set -g @tmux2k-right-plugins "battery cpu gpu ram langs time"
```

## Color palette

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

## Syncing with upstream

```bash
git fetch upstream
git rebase upstream/main
# resolve conflicts in the modified files if any
git push origin main
```

## Source

- Upstream: [2kabhishek/tmux2k](https://github.com/2kabhishek/tmux2k)
- Full plugin and options documentation: see upstream README
