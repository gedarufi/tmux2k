# tmux2k — gedarufi fork

Personal fork of [2kabhishek/tmux2k](https://github.com/2kabhishek/tmux2k) with customizations for gedarufi's environment.

## Installation (tpm)

```bash
set -g @plugin 'gedarufi/tmux2k'
```

`prefix + I` to install.

## Current layout (Tokyo Night Storm)

```
[● win1][● win2]...        [Path][Git][Langs][Time][Session]
```

```bash
set -g @tmux2k-left-plugins ""
set -g @tmux2k-right-plugins "path git langs time session"
```

Window pills: centered. Active = magenta with white text. Inactive = dark-gray pill with blue badge (icon + number) and white name.

## Modified plugins

### `session.sh`
- Shows OS icon (macOS, Linux, WSL)
- Numeric session names show icon only (no number)
- `@tmux2k-session-icon` — override icon
- `@tmux2k-session-show-user "true"` — appends username: ` gedarufi · dev`
- `@tmux2k-session-show-window-count "true"` — appends count: ` dev [3]`

### `path.sh`
Compact agnoster style: `~/Documents/coding/synkron/code` → ` ~    code`
- `@tmux2k-path-mode "git-root"` — shows repo name instead of pane path
- `@tmux2k-path-max-depth N` — collapse intermediate dirs to `…` beyond N levels

### `git.sh`
- Forge icon auto-detected from remote URL: GitHub, GitLab, Bitbucket, Forgejo, Gitea, Gogs, Codeberg (wildcard patterns for self-hosted)
- `@tmux2k-git-show-sync "true"` — ahead/behind indicators: `↑2 ↓1`
- `@tmux2k-git-show-stash "true"` — stash count: `  2`
- `@tmux2k-git-show-tag "true"` — exact tag if HEAD is tagged

### `langs.sh`
Detects project language from files in pane directory. **Hides entirely when no language detected.**

| Language   | Trigger files                              |
|------------|--------------------------------------------|
| Node.js    | `package.json`, `.nvmrc`, `.node-version`  |
| TypeScript | `tsconfig.json` (only if no Node triggers) |
| Bun        | `bun.lockb`, `bunfig.toml`                 |
| Deno       | `deno.json`, `deno.jsonc`                  |
| Python     | `requirements.txt`, `Pipfile`, `pyproject.toml`, `.python-version` |
| Go         | `go.mod`                                   |
| Rust       | `Cargo.toml`                               |
| Ruby       | `Gemfile`, `.ruby-version`                 |
| Elixir     | `mix.exs`                                  |
| Java       | `pom.xml`, `build.gradle`                  |
| Kotlin     | `build.gradle.kts`                         |
| Swift      | `Package.swift`                            |
| PHP        | `composer.json`, `.php-version`            |

### `battery.sh`
- `@tmux2k-battery-show-time "true"` — appends remaining time on macOS: ` 87% 2:30`

### `cpu.sh` / `gpu.sh` / `ram.sh`
- Removed `normalize_padding` → compact output: `13%` instead of ` 13% `

### Window pills — badge + process icon

Pills have a two-section layout: `[badge: icon + number][pill: name]`

- `@tmux2k-windows-show-process-icon "true"` — shows active pane's process icon in the badge
- `@tmux2k-window-badge-bg "blue"` — badge background color for inactive pills (default: `blue`)
- `@tmux2k-window-list-colors "bg_main magenta"` — active pill color (second value); first value = gap background, must match status bar bg
- Mapped commands: nvim, vim, python3, node, docker, git, bash/zsh/sh/fish, ssh, htop/top/btop, cargo, ruby, go, lua, make
- Unrecognized commands show a gear icon (U+F013) by default
- Active pill: uniform color, white text throughout
- Inactive pill: badge uses `@tmux2k-window-badge-bg`; left separator matches badge color

## New plugins

### `forge.sh`
Forge icon + repo name for the pane's git repo.
- `@tmux2k-forge-show-prs "true"` — fetches open PR/MR count (cached 5 min); requires `gh` or `glab`
- Output: ` gedarufi/tmux2k` or ` gedarufi/tmux2k  3`
- Hidden when pane is not in a git repo

### `music.sh`
Currently playing track.
- macOS: Spotify (`artist — track`) or Music.app
- Linux: `playerctl metadata`
- `@tmux2k-music-max-length 40` — truncate long strings
- Hidden when nothing is playing

### `kubectl.sh`
Kubernetes context and namespace.
- `@tmux2k-kubectl-show-namespace "true"` — appends `:namespace`
- Context names containing `prod`/`production` highlighted in red
- Shows `⎈ —` when kubectl unavailable or no context

### `vpn.sh`
VPN connection status.
- macOS: detects `utun*` interfaces; Linux: `tun0`/`ppp0`
- `@tmux2k-vpn-show-name "true"` — detects Tailscale, native macOS VPN, or shows `"VPN"`
- Connected: `shield_icon name`, disconnected: `lock_icon No VPN`

## Focus mode

`scripts/toggle-focus.sh` — hides/shows the status bar.
- State stored in `@tmux2k-focus-mode`
- Default binding: `prefix + F`

```bash
bind-key F run-shell "~/.tmux/plugins/tmux2k/scripts/toggle-focus.sh"
```

## Left plugins

Set to empty string to hide the left status bar entirely:

```bash
set -g @tmux2k-left-plugins ""
```

## Available but inactive plugins

Add to `@tmux2k-left-plugins` or `@tmux2k-right-plugins` to activate:

```bash
# forge, music, kubectl, vpn
set -g @tmux2k-right-plugins "path git forge music langs time session"
```

## Color palette (Tokyo Night Storm)

| Variable        | Hex       |
|-----------------|-----------|
| `bg-main`       | `#1e1e2e` |
| `black`         | `#1a1b26` |
| `dark-gray`     | `#3f3f4f` |
| `white`         | `#c0caf5` |
| `purple`        | `#bb9af7` |
| `blue`          | `#7aa2f7` |
| `light-blue`    | `#7dcfff` |
| `green`         | `#9ece6a` |
| `light-green`   | `#73daca` |
| `yellow`        | `#e0af68` |
| `red`           | `#f7768e` |
| `orange`        | `#ff9e64` |
| `magenta`       | `#c678dd` |

## Dev workflow

All changes go in this repo. The plugin dir (`~/.config/tmux/plugins/tmux2k/`) is tpm-managed — never copy files there directly.

```bash
# 1. Edit files here
# 2. Commit and push
git add -p && git commit -m "..." && git push
# 3. Update plugin dir
git -C ~/.config/tmux/plugins/tmux2k pull
tmux source ~/.config/tmux/tmux.conf
```

Copying directly to the plugin dir creates uncommitted local changes that block tpm updates.

## Syncing with upstream

```bash
git fetch upstream
git rebase upstream/main
# resolve conflicts in modified files
git push origin main
```

## Source

- Upstream: [2kabhishek/tmux2k](https://github.com/2kabhishek/tmux2k)
- Full upstream options: see upstream README
