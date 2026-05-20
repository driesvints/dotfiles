#!/usr/bin/env bash
# Break all panes in the current window into separate windows.
# Uses @pane_label (set during merge) as each new window's name.
# Iterates in reverse with -a so windows end up in original order after current.

current_window=$(tmux display-message -p "#{window_id}")
pane_count=$(tmux display-message -p "#{window_panes}")

if [ "$pane_count" -le 1 ]; then
    tmux display-message "Only one pane — use C-q M-m to merge windows in"
    exit 0
fi

# Collect all pane IDs and labels upfront (stable %N IDs won't shift as panes move)
declare -a pane_ids=()
declare -a pane_labels=()

while IFS=$'\t' read -r pane_id pane_label; do
    pane_ids+=("$pane_id")
    pane_labels+=("$pane_label")
done < <(tmux list-panes -t "$current_window" -F "#{pane_id}	#{@pane_label}")

total="${#pane_ids[@]}"

# Iterate in reverse, breaking each pane with -a (insert after current window).
# Reverse order ensures they end up in their original order after the current window.
for (( i=total-1; i>=0; i-- )); do
    pane_id="${pane_ids[$i]}"
    label="${pane_labels[$i]}"

    if [ "$i" -eq 0 ]; then
        # First pane stays in the current window — just rename it
        [ -n "$label" ] && tmux rename-window -t "$current_window" "$label"
    else
        if [ -n "$label" ]; then
            tmux break-pane -a -s "$pane_id" -n "$label"
        else
            tmux break-pane -a -s "$pane_id"
        fi
    fi
done
