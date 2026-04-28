#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

shield_icon=$(printf '\xef\x84\xb2')  # U+F132 (shield — connected)
lock_icon=$(printf '\xef\x80\xa3')    # U+F023 (lock — disconnected)

get_vpn_name() {
    # Tailscale
    if command -v tailscale &>/dev/null; then
        local ts_status
        ts_status=$(tailscale status 2>/dev/null | head -1)
        [[ -n "$ts_status" && "$ts_status" != *"stopped"* ]] && echo "Tailscale" && return
    fi
    # Native macOS VPN (System Settings > VPN)
    local sc_name
    sc_name=$(scutil --nc list 2>/dev/null | grep "Connected" | sed 's/.*"\(.*\)".*/\1/' | head -1)
    [[ -n "$sc_name" ]] && echo "$sc_name" && return
    # Generic fallback
    echo "VPN"
}

get_active_utun() {
    ifconfig 2>/dev/null | grep -E "^utun[0-9]" | awk -F: '{print $1}' | head -1
}

main() {
    local show_name
    show_name=$(get_tmux_option "@tmux2k-vpn-show-name" "true")

    local active_iface=""
    case "$(uname -s)" in
        Darwin) active_iface=$(get_active_utun) ;;
        Linux)
            ifconfig 2>/dev/null | grep -qE "^(tun0|ppp0)" && active_iface="tun0"
            ;;
    esac

    if [[ -n "$active_iface" ]]; then
        if [[ "$show_name" == "true" ]]; then
            local name
            name=$(get_vpn_name)
            echo "${shield_icon} ${name}"
        else
            echo "${shield_icon}"
        fi
    else
        echo "${lock_icon} No VPN"
    fi
}

main
