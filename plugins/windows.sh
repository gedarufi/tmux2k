#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

get_process_icon() {
    case "$1" in
        nvim|vim|vi)            printf '\xef\x97\x81' ;;  # U+F5C1
        python3|python|python2) printf '\xef\x87\xa3' ;;  # U+F1E3
        node|nodejs)            printf '\xed\xab\xa7' ;;  # U+FAEA
        docker)                 printf '\xef\xa4\xb7' ;;  # U+F937
        git)                    printf '\xef\xa7\x93' ;;  # U+F9D3
        bash|zsh|sh|fish)       printf '\xef\x84\xa1' ;;  # U+F121
        ssh)                    printf '\xef\x82\xa0' ;;  # U+F0A0
        htop|top|btop)          printf '\xef\x87\x9c' ;;  # U+F1DC
        cargo|rustc)            printf '\xe2\x9a\x99'  ;;  # U+2699 ⚙
        ruby)                   printf '\xef\x87\xa5' ;;  # U+F1E5
        go)                     printf '\xef\xbc\x91' ;;  # U+FF11 ﳑ
        lua)                    printf '\xef\x8b\x82' ;;  # U+F2C2
        make)                   printf '\xef\x84\xa3' ;;  # U+F123
        *)                      echo "" ;;
    esac
}

main() {
    local show_icon
    show_icon=$(get_tmux_option "@tmux2k-windows-show-process-icon" "false")

    local active_ind inactive_ind
    active_ind=$(printf '\xef\x91\x84')
    inactive_ind=$(printf '\xef\x90\xbc')

    local output=""
    while IFS=$'\t' read -r active cmd name; do
        local ind
        [[ "$active" == "1" ]] && ind="$active_ind" || ind="$inactive_ind"

        if [[ "$show_icon" == "true" ]]; then
            local icon
            icon=$(get_process_icon "$cmd")
            output+="$ind $icon $name  "
        else
            output+="$ind $name  "
        fi
    done < <(tmux list-windows -F "#{window_active}	#{pane_current_command}	#{window_name}")

    echo " ${output%  }"
}

main
