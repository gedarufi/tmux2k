#!/usr/bin/env bash

get_tmux_option() {
    local option=$1
    local default_value=$2
    if tmux show-option -gq "$option" 2>/dev/null | grep -q "^${option}"; then
        tmux show-option -gqv "$option"
    else
        echo "$default_value"
    fi
}

normalize_padding() {
    percent_len=${#1}
    max_len=${2:-4}
    let diff_len=$max_len-$percent_len
    # if the diff_len is even, left will have 1 more space than right
    let left_spaces=($diff_len + 1)/2
    let right_spaces=($diff_len)/2
    printf "%${left_spaces}s%s%${right_spaces}s\n" "" $1 ""
}

get_pane_dir() {
    nextone="false"
    ret=""
    for i in $(tmux list-panes -F "#{pane_active} #{pane_current_path}"); do
        [ "$i" == "1" ] && nextone="true" && continue
        [ "$i" == "0" ] && nextone="false"
        [ "$nextone" == "true" ] && ret+="$i "
    done
    echo "${ret%?}"
}
