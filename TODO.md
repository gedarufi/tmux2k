# TODO — tmux2k gedarufi fork

Plugin improvement ideas, sorted by priority and complexity.

---

## Improvements to existing plugins

### ~~`plugins/git.sh` — Forge detection from remote URL~~ ✅

Wildcard patterns for self-hosted instances (`*gitlab*`, `*gitea*`, `*forgejo*`, `*bitbucket*`, `*gogs*`). Falls back to `$repo_icon` for unknown remotes. Forge icon shown in clean state; `diff_icon` takes over when dirty.

---

### ~~`plugins/git.sh` — Additional info~~ ✅

- [x] **Ahead/behind:** `↑2 ↓1` via `rev-list --left-right --count HEAD...@{u}` — configurable with `@tmux2k-git-show-sync`
- [x] **Stash:** `` + count via `git stash list | wc -l` — configurable with `@tmux2k-git-show-stash`
- [x] **Tag:** ` tagname` via `git describe --exact-match --tags` — configurable with `@tmux2k-git-show-tag`

---

### `plugins/langs.sh` — Missing languages

| Language   | Detection file                | Icon |
|------------|-------------------------------|------|
| Rust       | `Cargo.toml`                  |     |
| TypeScript | `tsconfig.json`               |     |
| Bun        | `bun.lockb` / `bunfig.toml`   |     |
| Deno       | `deno.json` / `deno.jsonc`    |     |
| Elixir     | `mix.exs`                     |     |
| Java       | `pom.xml` / `build.gradle`    |     |
| Kotlin     | `build.gradle.kts`            |     |
| Swift      | `Package.swift`               |     |

---

### `plugins/session.sh` — Window count

- [ ] Option to show the session's window count: ` dev [3]`
- Configurable via `@tmux2k-session-show-window-count true`
- Implement with `tmux list-windows | wc -l`

---

### `plugins/path.sh` — Git root mode

- [ ] New option `@tmux2k-path-mode`: `pane` (current behavior) | `git-root`
- In `git-root` mode: shows the git repository name instead of the pane directory
- Example: from any subdirectory of `~/Documents/coding/synkron/src/api/` it would show ` synkron`
- Detect with `git -C "$path" rev-parse --show-toplevel 2>/dev/null | xargs basename`

---

### `plugins/battery.sh` (upstream) — Time remaining

- [ ] Parse `pmset -g batt` on macOS to extract remaining time
- Output: ` 87% 2:30` instead of just ` 87%`
- Hide time when charging (shows `charging`)

---

## New plugins

### `plugins/forge.sh` — Repository hub

Dedicated plugin to show the platform + repo name + open activity.

```
 gedarufi/dotfiles  2
 user/project  5
```

- Detects forge from remote URL (same as the git.sh improvement)
- GitHub: PR count via `gh pr list --state open --json number | jq length`
- GitLab: MR count via `glab mr list --state opened | wc -l`
- Hide PR/MR count if CLI is not available
- Config: `@tmux2k-forge-show-prs true`

---

### `plugins/kubectl.sh` — Kubernetes context

```
⎈ prod-cluster:default
⎈ staging:api-ns
```

- Parse `kubectl config current-context` and `kubectl config view --minify -o jsonpath='{..namespace}'`
- Color red if the context contains "prod" or "production"
- Config: `@tmux2k-kubectl-show-namespace true`
- Show `⎈ —` if kubectl is not installed or no context is active

---

### `plugins/music.sh` — Now playing

```
 Radiohead — Karma Police
```

- macOS: AppleScript → Spotify, Music.app
  ```bash
  osascript -e 'tell app "Spotify" to (artist of current track) & " — " & (name of current track)'
  ```
- Linux: `playerctl metadata --format "{{ artist }} — {{ title }}"`
- If nothing is playing: show nothing (plugin hides itself)
- Config: `@tmux2k-music-max-length 40` to truncate

---

### `plugins/vpn.sh` — VPN status

```
 ProtonVPN
 No VPN
```

- macOS: detect active `utun*` interfaces via `ifconfig | grep -E "^utun"`
- Linux: detect `tun0` / `ppp0`
- Show name if available (e.g. from `scutil --nc list`)
- Green icon  if connected, red  if disconnected
- Config: `@tmux2k-vpn-show-name true`

---

### `plugins/panes.sh` — Pane info

```
▣ 2/4
```

- Shows the active pane index and total count in the window
- `tmux display-message -p "#{pane_index}/#{window_panes}"`
- Useful in heavy split-pane workflows

---

## Visual / UX improvements

### `plugins/path.sh` — Configurable max depth

- [ ] `@tmux2k-path-max-depth N` — if there are more than N intermediate folders, show `...` in the middle
- Example with `max-depth 2`: `~ ...  code` instead of `~    code`

### `plugins/windows.sh` — Process icon per window

- [ ] Detect the running process in each window and add an icon to the pill
- `tmux list-windows -F "#{pane_current_command}"` to get the process
- Process → icon map: `nvim` → , `python3` → , `node` → , `docker` → , `git` → 
- Config: `@tmux2k-windows-show-process-icon true`

### Focus mode (status bar toggle)

- [ ] Keybind to collapse the status bar to just `[session] ... [time]`
- Toggle via: `bind-key F run-shell "$current_dir/scripts/toggle-focus.sh"`
- State persisted in tmux option (`@tmux2k-focus-mode on/off`)

---

## Fork infrastructure

### `sync-from-upstream.sh`

Script to sync with upstream without losing customizations:

```bash
#!/usr/bin/env bash
git fetch upstream
git rebase upstream/main
# Reports conflicts and stops if any
```

Run with: `./sync-from-upstream.sh`

### `.github/workflows/sync-check.yml` (optional)

GitHub Action that automatically opens an issue/PR when the upstream `2kabhishek/tmux2k` has new commits not yet in this fork. Uses `actions/checkout` + SHA comparison.

---

## Suggested priority

| Priority | Item |
|----------|------|
| ✅ Done | `git.sh` — forge detection (GitHub/GitLab/Bitbucket + self-hosted) |
| ✅ Done | `git.sh` — ahead/behind + stash + tag |
| 🔴 High | `langs.sh` — add Rust, TypeScript, Bun |
| 🟡 Medium | `forge.sh` — hub plugin with PR/MR count |
| 🟡 Medium | `music.sh` — now playing |
| 🟢 Low | `kubectl.sh` — Kubernetes context |
| 🟢 Low | `vpn.sh` — VPN status |
| 🟢 Low | `path.sh` — git-root mode |
| 🟢 Low | Focus mode toggle |
