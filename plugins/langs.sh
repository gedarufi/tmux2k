#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

node_icon=""
python_icon=""
ruby_icon=""
go_icon="ﳑ"
php_icon=""

main() {
    local path
    path=$(get_pane_dir)
    local output=""

    # Node.js
    if [[ -f "$path/package.json" || -f "$path/.nvmrc" || -f "$path/.node-version" ]]; then
        local v
        v=$(node --version 2>/dev/null | sed 's/v//')
        [[ -n "$v" ]] && output+="${node_icon} $v  "
    fi

    # Python
    if [[ -f "$path/requirements.txt" || -f "$path/Pipfile" || -f "$path/pyproject.toml" || -f "$path/.python-version" ]]; then
        local v
        v=$(python3 --version 2>/dev/null | awk '{print $2}')
        [[ -n "$v" ]] && output+="${python_icon} $v  "
    fi

    # Go
    if [[ -f "$path/go.mod" ]]; then
        local v
        v=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
        [[ -n "$v" ]] && output+="${go_icon} $v  "
    fi

    # Ruby
    if [[ -f "$path/Gemfile" || -f "$path/.ruby-version" ]]; then
        local v
        v=$(ruby --version 2>/dev/null | awk '{print $2}')
        [[ -n "$v" ]] && output+="${ruby_icon} $v  "
    fi

    # PHP
    if [[ -f "$path/composer.json" || -f "$path/.php-version" ]]; then
        local v
        v=$(php --version 2>/dev/null | head -1 | awk '{print $2}')
        [[ -n "$v" ]] && output+="${php_icon} $v  "
    fi

    [[ -n "$output" ]] && echo " ${output%  }" || echo ""
}

main
