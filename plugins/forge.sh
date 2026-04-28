#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

github_icon=$(printf '\xee\x9c\x89')    # U+E709
gitlab_icon=$(printf '\xef\x8a\x96')    # U+F296
bitbucket_icon=$(printf '\xee\x9c\x83') # U+E703
git_icon=$(printf '\xee\x9c\x82')       # U+E702 (gitea / forgejo / gogs / fallback)
pr_icon=$(printf '\xef\x84\xa6')        # U+F126

get_forge_icon() {
    local url="$1"
    case "$url" in
        *github*)    echo "$github_icon" ;;
        *gitlab*)    echo "$gitlab_icon" ;;
        *bitbucket*) echo "$bitbucket_icon" ;;
        *forgejo*|*gitea*|*gogs*|*codeberg*) echo "$git_icon" ;;
        *)           echo "$git_icon" ;;
    esac
}

get_pr_count() {
    local url="$1"
    local show_prs
    show_prs=$(get_tmux_option "@tmux2k-forge-show-prs" "false")
    [[ "$show_prs" != "true" ]] && return

    local now cache_time cached
    now=$(date +%s)
    cache_time=$(get_tmux_option "@tmux2k-forge-cache-time" "0")
    cached=$(get_tmux_option "@tmux2k-forge-cache-prs" "")

    if [[ -n "$cached" && $((now - cache_time)) -lt 300 ]]; then
        [[ "$cached" -gt 0 ]] && echo " ${pr_icon} ${cached}"
        return
    fi

    local count=""
    case "$url" in
        *github*)
            command -v gh &>/dev/null && \
                count=$(gh pr list --state open 2>/dev/null | wc -l | tr -d ' ')
            ;;
        *gitlab*)
            command -v glab &>/dev/null && \
                count=$(glab mr list --state opened 2>/dev/null | wc -l | tr -d ' ')
            ;;
    esac

    if [[ -n "$count" ]]; then
        tmux set-option -g @tmux2k-forge-cache-time "$now"
        tmux set-option -g @tmux2k-forge-cache-prs "$count"
        [[ "$count" -gt 0 ]] && echo " ${pr_icon} ${count}"
    fi
}

main() {
    local path
    path=$(get_pane_dir)

    local remote_url
    remote_url=$(git -C "$path" remote get-url origin 2>/dev/null)
    if [[ -z "$remote_url" ]]; then
        echo ""
        return
    fi

    local repo_name
    repo_name=$(git -C "$path" rev-parse --show-toplevel 2>/dev/null | xargs basename)

    local forge_icon
    forge_icon=$(get_forge_icon "$remote_url")

    local pr_part
    pr_part=$(get_pr_count "$remote_url")

    echo "${forge_icon} ${repo_name}${pr_part}"
}

main
