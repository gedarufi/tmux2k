# tmux2k-gedarufi

Personal fork of [2kabhishek/tmux2k](https://github.com/2kabhishek/tmux2k) with specific customizations for gedarufi's environment.

## Purpose

Preserve changes made on top of the original tmux2k plugin so they are not lost when updating via tpm. The plugin is referenced from `~/.config/tmux/tmux.conf`.

## Workflow

Changes must always go through the dev repo, never directly to the plugin dir:

1. Edit files in `/Users/gedarufi/Documents/coding/tmux2k_gedarufi/`
2. Commit and push to `https://github.com/gedarufi/tmux2k`
3. The plugin dir at `~/.config/tmux/plugins/tmux2k/` is a tpm-managed clone — update it via `git pull` or tpm, never via `cp`

Copying files directly to the plugin dir creates uncommitted local changes that block tpm updates.

## Icon convention

All Nerd Font icons are defined with `printf '\xHH\xHH\xHH'` (hex escapes), never as literal UTF-8 characters. The Write tool strips non-ASCII bytes, so literal icons are lost on any file rewrite. Always use printf.

## Modified files from upstream

### `plugins/cpu.sh` / `plugins/gpu.sh` / `plugins/ram.sh`
- Removed `normalize_padding` → compact output: `13%` instead of ` 13% `

### `lib/utils.sh`
- `get_tmux_option()`: fixed to distinguish between option set to `""` vs option not set at all — uses `tmux show-option -gq | grep` to detect presence before reading value with `-gqv`
- Without this fix, `@tmux2k-left-plugins ""` falls back to default `"session git cwd"` instead of empty

### `plugins/git.sh`
- `get_forge_icon()`: detects GitHub, GitLab, Bitbucket, Forgejo, Gitea, Gogs, Codeberg from remote URL using wildcard patterns for self-hosted support
- All forge icons use printf hex escapes
- `get_message()`: forge icon always shown regardless of uncommitted changes — previously it was hidden when the repo was dirty
- Options: `@tmux2k-git-show-sync`, `@tmux2k-git-show-stash`, `@tmux2k-git-show-tag`

### `plugins/path.sh`
Compact agnoster style. Options:
- `@tmux2k-path-mode`: `pane` (default) | `git-root` — in git-root mode shows repo name instead of pane path
- `@tmux2k-path-max-depth`: integer (default `0` = unlimited) — if intermediate dirs exceed N, collapses to `…`
- All icons (home, folder, git) use printf hex escapes

### `plugins/session.sh`
- Shows OS icon (macOS, Linux, WSL) via printf hex
- Options:
  - `@tmux2k-session-icon`: override icon
  - `@tmux2k-session-show-user`: `"true"` → appends `$(whoami)` — format: ` gedarufi · dev`
  - `@tmux2k-session-show-window-count`: `"true"` → appends `[N]` — format: ` dev [3]`
- Numeric session names suppress the name, showing only icon (+ user/count if enabled)

### `plugins/langs.sh`
Detects project language by file presence in pane directory. Hides segment completely when no language detected (see hide-when-empty mechanism below).

Detected languages and their trigger files:

| Language   | Trigger file(s)               |
|------------|-------------------------------|
| Node.js    | `package.json`, `.nvmrc`, `.node-version` |
| TypeScript | `tsconfig.json` (only if no Node triggers) |
| Bun        | `bun.lockb`, `bunfig.toml`    |
| Deno       | `deno.json`, `deno.jsonc`     |
| Python     | `requirements.txt`, `Pipfile`, `pyproject.toml`, `.python-version` |
| Go         | `go.mod`                      |
| Rust       | `Cargo.toml`                  |
| Ruby       | `Gemfile`, `.ruby-version`    |
| Elixir     | `mix.exs`                     |
| Java       | `pom.xml`, `build.gradle`     |
| Kotlin     | `build.gradle.kts`            |
| Swift      | `Package.swift`               |
| PHP        | `composer.json`, `.php-version` |

### `plugins/battery.sh`
- Option: `@tmux2k-battery-show-time`: `"true"` → appends remaining time on macOS (parses `pmset -g batt`)
- Format: ` 87% 2:30`

### `plugins/process-icon.sh`
- Maps process name to Nerd Font icon via printf hex escapes
- Mapped: nvim, vim, python3, node, docker, git, bash/zsh/sh/fish, ssh, htop/top/btop, cargo/rustc, ruby, go, lua, make
- Default for unrecognized processes: gear icon U+F013 (`\xef\x80\x93`)

### `main.sh` — Window pill badge system
Pills have two color sections: `[badge: icon + number][pill: name]`

- `@tmux2k-windows-show-process-icon "true"` — enables process icon in badge
- `@tmux2k-window-badge-bg "blue"` — badge background for inactive pills (default: `blue`)
- `@tmux2k-window-list-colors "bg_main magenta"` — first value = gap bg (must match status bar), second = active pill bg
- Active pill: uniform color, dark text (`wbg`), no inner badge
- Inactive pill: badge uses `badge_bg`; left separator matches badge color; name on `bg_alt`
- `magenta` color variable added: `#c678dd` (configurable via `@tmux2k-magenta`)

## New plugins

### `plugins/forge.sh`
Shows forge icon + repo name for the current pane's git repo.
- Options:
  - `@tmux2k-forge-show-prs "true"` → fetches open PR/MR count (cached 5 min in `@tmux2k-forge-cache-*`)
  - Requires `gh` (GitHub) or `glab` (GitLab) CLI for PR count
- Output: ` gedarufi/tmux2k` or ` gedarufi/tmux2k  3`
- Returns empty if pane is not in a git repo

### `plugins/music.sh`
Shows currently playing track.
- macOS: Spotify → `spotify_icon artist — track`, Music.app → `music_icon artist — track`
- Linux: `playerctl metadata`
- Option: `@tmux2k-music-max-length` (default `40`) — truncates long strings
- Returns empty if nothing is playing (segment hidden via hideable mechanism)

### `plugins/kubectl.sh`
Shows current Kubernetes context and namespace.
- Option: `@tmux2k-kubectl-show-namespace "true"` (default) → appends `:namespace`
- Red highlight if context name contains `prod` or `production`
- Shows `⎈ —` if kubectl is not installed or no context is active

### `plugins/vpn.sh`
Detects active VPN connection.
- macOS: checks `utun*` interfaces via `ifconfig`; Linux: checks `tun0`/`ppp0`
- Option: `@tmux2k-vpn-show-name "true"` (default) → attempts to get VPN name
  - Name detection: Tailscale (`tailscale status`), native macOS (`scutil --nc list`), fallback `"VPN"`
- Connected: `shield_icon name`, disconnected: `lock_icon No VPN`

## Focus mode

`scripts/toggle-focus.sh` — toggles `status on/off` via `tmux set-option`.
- State stored in `@tmux2k-focus-mode` (`on`/`off`)
- Bound to `prefix + F` in `tmux.conf`

## Hide-when-empty mechanism

Plugins that support hiding set two tmux options instead of echoing output:
- `@tmux2k-<plugin>-output`: `"1"` when visible, `""` when hidden
- `@tmux2k-<plugin>-content`: the display string (plain text, no color codes)
- Plugin echoes nothing (empty stdout)

In `main.sh`, `status_bar()` handles hideable plugins differently:
- `$script` (`#(plugin.sh)`) runs **outside** `#{?}` — always executes to update options
- Display: `#{?@tmux2k-<plugin>-output, SEG_WITH_#{@tmux2k-<plugin>-content} ,}`
- The following plugin's separator bg is conditional via `#{?@tmux2k-<plugin>-output,plugin_bg,prev_bg}` — no color artifact when hidden

Configured via `@tmux2k-hideable-plugins` (default: `"langs music forge"`).

**Important**: All `#[fg=X,bg=Y]` inside `#{?}` conditionals must be split to `#[fg=X]#[bg=Y]` — tmux does not protect commas inside `#[...]` from being treated as conditional separators.

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
| `magenta`          | `#c678dd` |

## Current layout

```
[● win1][● win2]...        [Path][Git][Langs][Time][Session]
```

```bash
set -g @tmux2k-left-plugins ""
set -g @tmux2k-right-plugins "path git langs time session"
```

- Left bar: empty (set `@tmux2k-left-plugins ""` — requires utils.sh fix to work)
- Window list: centered pills
- Active window: magenta pill, dark text
- Inactive window: dark-gray pill with blue badge (icon + number), white name
- Process icon in pills: enabled via `@tmux2k-windows-show-process-icon "true"`

## Available but inactive plugins

These plugins exist and work but are not in the current layout. Add to `@tmux2k-left-plugins` or `@tmux2k-right-plugins` to activate:

- `forge` — repo name + forge icon + optional PR/MR count
- `music` — now playing
- `kubectl` — Kubernetes context
- `vpn` — VPN status
