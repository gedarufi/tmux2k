#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

get_os_icon() {
    case "$(uname -s)" in
        Darwin) echo "" ;;
        Linux)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo " WSL"
            else
                echo ""
            fi
            ;;
        *) echo "" ;;
    esac
}

main() {
    local icon
    icon=$(get_tmux_option "@tmux2k-session-icon" "$(get_os_icon)")
    local name
    name=$(tmux display-message -p "#S")

    if [[ "$name" =~ ^[0-9]+$ ]]; then
        echo "$icon"
    else
        echo "$icon $name"
    fi
}

main
