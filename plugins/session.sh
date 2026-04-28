#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

get_os_icon() {
    case "$(uname -s)" in
        Darwin) printf '\xef\x85\xb9\n' ;;
        Linux)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                printf '\xef\x8c\x9a WSL\n'
            else
                printf '\xef\x8c\x9a\n'
            fi
            ;;
        *) printf '\xee\xaf\x88\n' ;;
    esac
}

main() {
    local icon
    icon=$(get_tmux_option "@tmux2k-session-icon" "$(get_os_icon)")
    local name
    name=$(tmux display-message -p "#S")
    local show_user
    show_user=$(get_tmux_option "@tmux2k-session-show-user" "false")

    local user_part=""
    if [[ "$show_user" == "true" ]]; then
        user_part=" $(whoami)"
    fi

    if [[ "$name" =~ ^[0-9]+$ ]]; then
        echo "$icon$user_part"
    else
        if [[ "$show_user" == "true" ]]; then
            echo "$icon$user_part · $name"
        else
            echo "$icon $name"
        fi
    fi
}

main
