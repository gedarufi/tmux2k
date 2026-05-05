#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

display_status=$(get_tmux_option '@tmux2k-git-display-status' 'false')
added_icon=$(get_tmux_option '@tmux2k-git-added-icon' '')
modified_icon=$(get_tmux_option '@tmux2k-git-modified-icon' '')
updated_icon=$(get_tmux_option '@tmux2k-git-updated-icon' '')
deleted_icon=$(get_tmux_option '@tmux2k-git-deleted-icon' '')
repo_icon=$(get_tmux_option '@tmux2k-git-repo-icon' '')
diff_icon=$(get_tmux_option '@tmux2k-git-diff-icon' '')
no_repo_icon=$(get_tmux_option '@tmux2k-git-no-repo-icon' '')
show_sync=$(get_tmux_option '@tmux2k-git-show-sync' 'true')
show_stash=$(get_tmux_option '@tmux2k-git-show-stash' 'true')
show_tag=$(get_tmux_option '@tmux2k-git-show-tag' 'true')

get_forge_icon() {
    local remote_url
    remote_url=$(git -C "$path" remote get-url origin 2>/dev/null)
    local gh gl bb git_ic
    gh=$(printf '\xee\x9c\x89')    # U+E709 GitHub
    gl=$(printf '\xef\x8a\x96')    # U+F296 GitLab
    bb=$(printf '\xee\x9c\x83')    # U+E703 Bitbucket
    git_ic=$(printf '\xee\x9c\x82') # U+E702 generic git
    # Wildcards for self-hosted: *gitlab*, *gitea*, *forgejo*, *bitbucket*, *gogs*
    case "$remote_url" in
        *github*)    echo "$gh" ;;
        *gitlab*)    echo "$gl" ;;
        *bitbucket*) echo "$bb" ;;
        *forgejo*|*gitea*|*gogs*|*codeberg*) echo "$git_ic" ;;
        *)           echo "$repo_icon" ;;
    esac
}

get_changes() {
    declare -i added=0
    declare -i modified=0
    declare -i updated=0
    declare -i deleted=0

    for i in $(git -C "$path" status -s); do
        case $i in
        'A') added+=1 ;;
        'M') modified+=1 ;;
        'U') updated+=1 ;;
        'D') deleted+=1 ;;
        esac
    done

    output=""
    [ $added -gt 0 ] && output+="${added} $added_icon"
    [ $modified -gt 0 ] && output+=" ${modified} $modified_icon"
    [ $updated -gt 0 ] && output+=" ${updated} $updated_icon"
    [ $deleted -gt 0 ] && output+=" ${deleted} $deleted_icon"

    echo "$output"
}

check_empty_symbol() {
    symbol=$1
    if [ "$symbol" == "" ]; then
        echo "true"
    else
        echo "false"
    fi
}

check_for_changes() {
    if [ "$(check_for_git_dir)" == "true" ]; then
        if [ "$(git -C "$path" status -s)" != "" ]; then
            echo "true"
        else
            echo "false"
        fi
    else
        echo "false"
    fi
}

check_for_git_dir() {
    if [ "$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null)" != "" ]; then
        echo "true"
    else
        echo "false"
    fi
}

get_branch() {
    if [ $(check_for_git_dir) == "true" ]; then
        printf "%.20s " $(git -C "$path" rev-parse --abbrev-ref HEAD)
    else
        echo "$no_repo_icon"
    fi
}

get_sync_status() {
    [ "$show_sync" != "true" ] && return
    local counts
    counts=$(git -C "$path" rev-list --left-right --count HEAD...@{u} 2>/dev/null) || return
    local ahead behind
    ahead=$(echo "$counts" | awk '{print $1}')
    behind=$(echo "$counts" | awk '{print $2}')
    local output=""
    [ "$ahead" -gt 0 ] && output+=" ↑${ahead}"
    [ "$behind" -gt 0 ] && output+=" ↓${behind}"
    echo "$output"
}

get_stash_info() {
    [ "$show_stash" != "true" ] && return
    local count
    count=$(git -C "$path" stash list 2>/dev/null | wc -l | tr -d ' ')
    [ "$count" -gt 0 ] && echo "  ${count}"
}

get_tag_info() {
    [ "$show_tag" != "true" ] && return
    local tag
    tag=$(git -C "$path" describe --exact-match --tags 2>/dev/null) || return
    [ -n "$tag" ] && echo "  ${tag}"
}

get_message() {
    if [ $(check_for_git_dir) == "true" ]; then
        local branch forge_icon extra prefix
        branch="$(get_branch)"
        forge_icon="$(get_forge_icon)"
        extra="$(get_tag_info)$(get_sync_status)$(get_stash_info)"

        if [ $(check_empty_symbol "$forge_icon") == "true" ]; then
            prefix=""
        else
            prefix="$forge_icon "
        fi

        if [ $(check_for_changes) == "true" ]; then
            local changes
            changes="$(get_changes)"

            if [ "${display_status}" == "false" ]; then
                if [ $(check_empty_symbol "$diff_icon") == "true" ]; then
                    echo "${prefix}${changes} ${branch}${extra}"
                else
                    echo "${prefix}${diff_icon} ${changes} ${branch}${extra}"
                fi
            else
                if [ $(check_empty_symbol "$diff_icon") == "true" ]; then
                    echo "${prefix}${branch}${extra}"
                else
                    echo "${prefix}${diff_icon} ${branch}${extra}"
                fi
            fi
        else
            echo "${prefix}${branch}${extra}"
        fi
    else
        echo "$no_repo_icon"
    fi
}

main() {
    path=$(get_pane_dir)
    get_message
}

main
