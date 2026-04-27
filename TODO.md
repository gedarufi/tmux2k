# TODO — tmux2k gedarufi fork

Ideas de mejora para los plugins. Marcadas por prioridad/complejidad.

---

## Mejoras a plugins existentes

### `plugins/git.sh` — Detección de forge por remote URL

Actualmente usa siempre el mismo ícono de repo (). La idea es parsear la URL del remote para mostrar el ícono correcto de la plataforma.

**Implementación:**
```bash
remote_url=$(git -C "$path" remote get-url origin 2>/dev/null)
case "$remote_url" in
    *github.com*)   forge_icon="" ;;
    *gitlab.com*)   forge_icon="" ;;
    *bitbucket.org*) forge_icon="" ;;
    *codeberg.org*) forge_icon="󰊢" ;;
    *)              forge_icon="" ;;  # gitea/forgejo/otro
esac
```

Reemplaza `$repo_icon` por `$forge_icon` en `get_message()`.

---

### `plugins/git.sh` — Información adicional

- [ ] **Ahead/behind:** mostrar `↑2 ↓1` cuando la rama tiene diferencias con el upstream remoto
  ```bash
  git rev-list --count HEAD...@{u} 2>/dev/null
  ```
- [ ] **Stash:** mostrar `` + conteo si hay stashes (`git stash list | wc -l`)
- [ ] **Tag:** mostrar el tag si HEAD está exactamente en uno (`git describe --exact-match --tags 2>/dev/null`)

---

### `plugins/langs.sh` — Lenguajes faltantes

| Lenguaje   | Archivo de detección          | Ícono |
|------------|-------------------------------|-------|
| Rust       | `Cargo.toml`                  |      |
| TypeScript | `tsconfig.json`               |      |
| Bun        | `bun.lockb` / `bunfig.toml`   |      |
| Deno       | `deno.json` / `deno.jsonc`    |      |
| Elixir     | `mix.exs`                     |      |
| Java       | `pom.xml` / `build.gradle`    |      |
| Kotlin     | `build.gradle.kts`            |      |
| Swift      | `Package.swift`               |      |

---

### `plugins/session.sh` — Conteo de ventanas

- [ ] Opción para añadir el conteo de ventanas de la sesión: ` dev [3]`
- Configurable con `@tmux2k-session-show-window-count true`
- Implementar con `tmux list-windows | wc -l`

---

### `plugins/path.sh` — Modo raíz de repositorio

- [ ] Nueva opción `@tmux2k-path-mode`: `pane` (comportamiento actual) | `git-root`
- En modo `git-root`: muestra el nombre del repositorio git en lugar del directorio del pane
- Ejemplo: desde cualquier subdirectorio de `~/Documents/coding/synkron/src/api/` mostraría ` synkron`
- Detectar con `git -C "$path" rev-parse --show-toplevel 2>/dev/null | xargs basename`

---

### `plugins/battery.sh` (upstream) — Tiempo restante

- [ ] Parsear `pmset -g batt` en macOS para extraer tiempo restante
- Output: ` 87% 2:30` en lugar de solo ` 87%`
- Ocultar el tiempo cuando está cargando (muestra `charging`)

---

## Plugins nuevos

### `plugins/forge.sh` — Hub del repositorio

Plugin dedicado para mostrar la plataforma + nombre del repo + actividad abierta.

```
 gedarufi/dotfiles  2
 usuario/proyecto  5
```

- Detecta forge desde remote URL (igual que la mejora de git.sh)
- GitHub: PR count con `gh pr list --state open --json number | jq length`
- GitLab: MR count con `glab mr list --state opened | wc -l`
- Ocultar PR/MR count si el CLI no está disponible
- Config: `@tmux2k-forge-show-prs true`

---

### `plugins/kubectl.sh` — Kubernetes context

```
⎈ prod-cluster:default
⎈ staging:api-ns
```

- Parsear `kubectl config current-context` y `kubectl config view --minify -o jsonpath='{..namespace}'`
- Colorear en rojo si el contexto contiene "prod" o "production"
- Config: `@tmux2k-kubectl-show-namespace true`
- Mostrar `⎈ —` si kubectl no está instalado o no hay contexto activo

---

### `plugins/music.sh` — Reproducción actual

```
 Radiohead — Karma Police
 Sin reproducción
```

- macOS: AppleScript → Spotify, Music.app
  ```bash
  osascript -e 'tell app "Spotify" to (artist of current track) & " — " & (name of current track)'
  ```
- Linux: `playerctl metadata --format "{{ artist }} — {{ title }}"`
- Si no hay nada reproduciéndose: no mostrar nada (plugin se oculta)
- Config: `@tmux2k-music-max-length 40` para truncar

---

### `plugins/vpn.sh` — Estado de VPN

```
 ProtonVPN
 Sin VPN
```

- macOS: detectar interfaces `utun*` activas con `ifconfig | grep -E "^utun"`
- Linux: detectar `tun0` / `ppp0`
- Mostrar nombre si está disponible (ej. desde `scutil --nc list`)
- Ícono verde  si conectado, rojo  si desconectado
- Config: `@tmux2k-vpn-show-name true`

---

### `plugins/panes.sh` — Info de panes

```
▣ 2/4
```

- Muestra el índice del pane activo y el total en la ventana
- `tmux display-message -p "#{pane_index}/#{window_panes}"`
- Útil en sesiones de trabajo intensivo con splits

---

## Mejoras visuales / UX

### `plugins/path.sh` — Profundidad máxima configurable

- [ ] `@tmux2k-path-max-depth N` — si hay más de N carpetas intermedias, mostrar `...` en el medio
- Ejemplo con `max-depth 2`: `~ ...  code` en lugar de `~    code`

### `plugins/windows.sh` — Ícono por proceso

- [ ] Detectar el proceso corriendo en cada ventana y añadir ícono a la pill
- `tmux list-windows -F "#{pane_current_command}"` para obtener el proceso
- Mapa de proceso → ícono: `nvim` → , `python3` → , `node` → , `docker` → , `git` → 
- Config: `@tmux2k-windows-show-process-icon true`

### Modo "focus" (toggle de barra)

- [ ] Keybind para colapsar el status bar a solo `[session] ... [time]`
- Toggle vía: `bind-key F run-shell "$current_dir/scripts/toggle-focus.sh"`
- Estado persistido en opción tmux (`@tmux2k-focus-mode on/off`)

---

## Infraestructura del fork

### `sync-from-upstream.sh`

Script para sincronizar con el upstream sin perder las customizaciones:

```bash
#!/usr/bin/env bash
git fetch upstream
git rebase upstream/main
# Si hay conflictos, los reporta y para
```

Ejecutar con: `./sync-from-upstream.sh`

### `.github/workflows/sync-check.yml` (opcional)

GitHub Action que crea un issue/PR automáticamente cuando el upstream `2kabhishek/tmux2k` tiene nuevos commits que no están en este fork. Usa `actions/checkout` + comparación de SHAs.

---

## Prioridad sugerida

| Prioridad | Item |
|-----------|------|
| 🔴 Alta | `git.sh` — detección de forge (GitHub/GitLab/Bitbucket) |
| 🔴 Alta | `langs.sh` — añadir Rust, TypeScript, Bun |
| 🟡 Media | `forge.sh` — plugin de hub con PR/MR count |
| 🟡 Media | `git.sh` — ahead/behind + stash |
| 🟡 Media | `music.sh` — reproducción actual |
| 🟢 Baja | `kubectl.sh` — Kubernetes context |
| 🟢 Baja | `vpn.sh` — estado de VPN |
| 🟢 Baja | `path.sh` — modo git-root |
| 🟢 Baja | Modo "focus" toggle |
