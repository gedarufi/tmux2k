#!/usr/bin/env bash
current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

music_icon=$(printf '\xef\x80\xa5')    # U+F025 (music note)
spotify_icon=$(printf '\xef\x86\xbc')  # U+F1BC (spotify)

get_now_playing() {
    case "$(uname -s)" in
        Darwin)
            # Try Spotify first
            if osascript -e 'application "Spotify" is running' 2>/dev/null | grep -q true; then
                local artist track state
                state=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
                if [[ "$state" == "playing" ]]; then
                    artist=$(osascript -e 'tell application "Spotify" to artist of current track' 2>/dev/null)
                    track=$(osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null)
                    echo "${spotify_icon} ${artist} — ${track}"
                    return
                fi
            fi
            # Try Music.app
            if osascript -e 'application "Music" is running' 2>/dev/null | grep -q true; then
                local artist track state
                state=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
                if [[ "$state" == "playing" ]]; then
                    artist=$(osascript -e 'tell application "Music" to artist of current track' 2>/dev/null)
                    track=$(osascript -e 'tell application "Music" to name of current track' 2>/dev/null)
                    echo "${music_icon} ${artist} — ${track}"
                    return
                fi
            fi
            ;;
        Linux)
            command -v playerctl &>/dev/null || return
            local status
            status=$(playerctl status 2>/dev/null)
            [[ "$status" != "Playing" ]] && return
            local info
            info=$(playerctl metadata --format "{{ artist }} — {{ title }}" 2>/dev/null)
            [[ -n "$info" ]] && echo "${music_icon} ${info}"
            ;;
    esac
}

main() {
    local max_length
    max_length=$(get_tmux_option "@tmux2k-music-max-length" "40")

    local output
    output=$(get_now_playing)
    [[ -z "$output" ]] && return

    if [[ ${#output} -gt $max_length ]]; then
        output="${output:0:$((max_length - 1))}…"
    fi

    echo "$output"
}

main
