#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

main() {
    local raw
    raw=$(get_pane_dir)
    local cwd
    cwd=$(echo "$raw" | sed "s|$HOME|~|")
    local sep="  "
    local home_icon=""
    local folder_icon=""

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

    for ((i = 1; i < len - 1; i++)); do
        [[ -n "${parts[$i]}" ]] && result+="${sep}${folder_icon}"
    done

    result+="${sep}${parts[len-1]}"
    echo " $result"
}

main
