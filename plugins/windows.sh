#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

main() {
    local output=""
    while IFS= read -r line; do
        output+="$line  "
    done < <(tmux list-windows -F "#{?window_active,,} #{window_name}")
    echo " ${output%  }"
}

main
