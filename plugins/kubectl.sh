#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

k8s_icon=$(printf '\xe2\x8e\x88')  # U+2388 (helm/k8s wheel ⎈)

main() {
    if ! command -v kubectl &>/dev/null; then
        echo "${k8s_icon} —"
        return
    fi

    local context
    context=$(kubectl config current-context 2>/dev/null)
    if [[ -z "$context" ]]; then
        echo "${k8s_icon} —"
        return
    fi

    local show_namespace
    show_namespace=$(get_tmux_option "@tmux2k-kubectl-show-namespace" "true")

    local output="${k8s_icon} ${context}"

    if [[ "$show_namespace" == "true" ]]; then
        local ns
        ns=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null)
        [[ -z "$ns" ]] && ns="default"
        output+=" :${ns}"
    fi

    # Highlight prod contexts in red
    if [[ "$context" =~ prod(uction)? ]]; then
        output="#[fg=red]${output}#[default]"
    fi

    echo "$output"
}

main
