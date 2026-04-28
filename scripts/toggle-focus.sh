#!/usr/bin/env bash
current=$(tmux show-option -gv @tmux2k-focus-mode 2>/dev/null || echo "off")

if [[ "$current" == "on" ]]; then
    tmux set-option -g @tmux2k-focus-mode "off"
    tmux set-option -g status on
else
    tmux set-option -g @tmux2k-focus-mode "on"
    tmux set-option -g status off
fi
