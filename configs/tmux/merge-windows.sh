#!/usr/bin/env bash
# Merge selected windows (and all their panes) into the current window, then tile.

current_window=$(tmux display-message -p "#{window_id}")
current_index=$(tmux display-message -p "#I")
current_name=$(tmux display-message -p "#{window_name}")

# Build list of other windows (index TAB name TAB pane-count label)
window_list=$(tmux list-windows \
    -F "#I	#{window_name}	#{window_panes} pane#{?#{==:#{window_panes},1},,s}" \
    | grep -v "^${current_index}	")

if [ -z "$window_list" ]; then
    tmux display-message "No other windows to merge"
    exit 0
fi

# fzf popup — Tab to select multiple, Enter to confirm
selected=$(printf '%s\n' "$window_list" \
    | fzf-tmux -p 60%,40% \
        --multi \
        --with-nth=1,2,3 \
        --delimiter='	' \
        --prompt="Merge into '${current_name}' > " \
        --header="Tab: select  |  Enter: merge & tile  |  Ctrl-S: split current panes  |  Esc: cancel" \
        --bind "ctrl-s:execute(~/.tmux/split-panes.sh)+abort")

[ -z "$selected" ] && exit 0

# Collect ALL pane IDs and their source window names before moving anything
# (pane IDs are stable; window indices are not once panes start moving)
declare -A pane_labels   # pane_id -> source window name
merged_names=()

while IFS='	' read -r win_idx _rest; do
    win_name=$(tmux display-message -t ":${win_idx}" -p "#{window_name}")
    merged_names+=("$win_name")
    while IFS= read -r pane_id; do
        pane_labels["$pane_id"]="$win_name"
    done < <(tmux list-panes -t ":${win_idx}" -F "#{pane_id}" 2>/dev/null)
done <<< "$selected"

# Move all collected panes into the current window, then label each with its source window name
for pane_id in "${!pane_labels[@]}"; do
    tmux join-pane -s "$pane_id" -t "$current_window" 2>/dev/null || true
    tmux set-option -p -t "$pane_id" @pane_label "${pane_labels[$pane_id]}" 2>/dev/null || true
done

# Rename the current window to reflect the merge
if [ ${#merged_names[@]} -gt 0 ]; then
    new_name="${current_name}+$(IFS=+; echo "${merged_names[*]}")"
    tmux rename-window -t "$current_window" "$new_name"
fi

# Apply even grid layout
tmux select-layout tiled
