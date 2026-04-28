#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

node_icon=$(printf '\xee\x9c\x98')    # U+E718
python_icon=$(printf '\xee\x88\xb5')  # U+E235
ruby_icon=$(printf '\xee\x9e\x91')    # U+E791
go_icon=$(printf '\xef\xb3\x91')      # U+FCD1
php_icon=$(printf '\xee\x9c\xbd')     # U+E73D
rust_icon=$(printf '\xee\x9e\xa8')    # U+E7A8
ts_icon=$(printf '\xee\x98\xa8')      # U+E628
bun_icon=$(printf '\xee\x9c\x97')     # U+E717 (JS runtime fallback)
deno_icon=$(printf '\xee\x98\xa8')    # U+E628 (TS-first runtime)
elixir_icon=$(printf '\xee\x98\xad')  # U+E62D
java_icon=$(printf '\xee\x9c\xb8')    # U+E738
kotlin_icon=$(printf '\xee\x98\xb4')  # U+E634
swift_icon=$(printf '\xee\x9d\x95')   # U+E755

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

    # TypeScript (only if no package.json already triggered Node)
    if [[ -f "$path/tsconfig.json" && ! -f "$path/package.json" && ! -f "$path/.nvmrc" && ! -f "$path/.node-version" ]]; then
        local v
        v=$(npx tsc --version 2>/dev/null | awk '{print $2}')
        [[ -n "$v" ]] && output+="${ts_icon} $v  " || output+="${ts_icon}  "
    fi

    # Bun
    if [[ -f "$path/bun.lockb" || -f "$path/bunfig.toml" ]]; then
        local v
        v=$(bun --version 2>/dev/null)
        [[ -n "$v" ]] && output+="${bun_icon} $v  " || output+="${bun_icon}  "
    fi

    # Deno
    if [[ -f "$path/deno.json" || -f "$path/deno.jsonc" ]]; then
        local v
        v=$(deno --version 2>/dev/null | head -1 | awk '{print $2}')
        [[ -n "$v" ]] && output+="${deno_icon} $v  " || output+="${deno_icon}  "
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

    # Rust
    if [[ -f "$path/Cargo.toml" ]]; then
        local v
        v=$(rustc --version 2>/dev/null | awk '{print $2}')
        [[ -n "$v" ]] && output+="${rust_icon} $v  " || output+="${rust_icon}  "
    fi

    # Ruby
    if [[ -f "$path/Gemfile" || -f "$path/.ruby-version" ]]; then
        local v
        v=$(ruby --version 2>/dev/null | awk '{print $2}')
        [[ -n "$v" ]] && output+="${ruby_icon} $v  "
    fi

    # Elixir
    if [[ -f "$path/mix.exs" ]]; then
        local v
        v=$(elixir --version 2>/dev/null | grep "Elixir" | awk '{print $2}')
        [[ -n "$v" ]] && output+="${elixir_icon} $v  " || output+="${elixir_icon}  "
    fi

    # Java
    if [[ -f "$path/pom.xml" || -f "$path/build.gradle" ]]; then
        local v
        v=$(java -version 2>&1 | head -1 | sed 's/.*version "\(.*\)".*/\1/')
        [[ -n "$v" ]] && output+="${java_icon} $v  " || output+="${java_icon}  "
    fi

    # Kotlin
    if [[ -f "$path/build.gradle.kts" ]]; then
        local v
        v=$(kotlinc -version 2>&1 | awk '{print $NF}')
        [[ -n "$v" ]] && output+="${kotlin_icon} $v  " || output+="${kotlin_icon}  "
    fi

    # Swift
    if [[ -f "$path/Package.swift" ]]; then
        local v
        v=$(swift --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?')
        [[ -n "$v" ]] && output+="${swift_icon} $v  " || output+="${swift_icon}  "
    fi

    # PHP
    if [[ -f "$path/composer.json" || -f "$path/.php-version" ]]; then
        local v
        v=$(php --version 2>/dev/null | head -1 | awk '{print $2}')
        [[ -n "$v" ]] && output+="${php_icon} $v  "
    fi

    if [[ -n "$output" ]]; then
        tmux set-option -gq "@tmux2k-langs-output" "1" 2>/dev/null
        echo " ${output%  }"
    else
        tmux set-option -gq "@tmux2k-langs-output" "" 2>/dev/null
        echo ""
    fi
}

main
