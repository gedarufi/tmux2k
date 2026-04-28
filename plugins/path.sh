#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

main() {
    local mode
    mode=$(get_tmux_option "@tmux2k-path-mode" "pane")
    local max_depth
    max_depth=$(get_tmux_option "@tmux2k-path-max-depth" "0")

    local sep
    sep=" $(printf '\xee\x82\xb1') "   # U+E0B1
    local home_icon
    home_icon=$(printf '\xee\xac\x86') # U+EB06
    local folder_icon
    folder_icon=$(printf '\xef\x84\x95') # U+F115
    local git_icon
    git_icon=$(printf '\xee\x9c\x82')  # U+E702

    if [[ "$mode" == "git-root" ]]; then
        local pane_path git_root
        pane_path=$(get_pane_dir)
        git_root=$(git -C "$pane_path" rev-parse --show-toplevel 2>/dev/null)
        if [[ -n "$git_root" ]]; then
            echo " ${git_icon} $(basename "$git_root")"
            return
        fi
    fi

    local raw
    raw=$(get_pane_dir)
    local cwd
    cwd=$(echo "$raw" | sed "s|$HOME|~|")

    IFS='/' read -ra parts <<< "$cwd"
    local len=${#parts[@]}

    if [[ $len -le 1 ]]; then
        echo " ${home_icon}"
        return
    fi

    local result
    if [[ "${parts[0]}" == "~" ]]; then
        result="${home_icon}"
    else
        result="${parts[0]}"
    fi

    local intermediates=()
    for ((i = 1; i < len - 1; i++)); do
        [[ -n "${parts[$i]}" ]] && intermediates+=("${parts[$i]}")
    done

    local mid_count=${#intermediates[@]}
    if [[ "$max_depth" -gt 0 && "$mid_count" -gt "$max_depth" ]]; then
        result+="${sep}…"
    else
        for ((i = 0; i < mid_count; i++)); do
            result+="${sep}${folder_icon}"
        done
    fi

    result+="${sep}${parts[len-1]}"
    echo " $result"
}

main
