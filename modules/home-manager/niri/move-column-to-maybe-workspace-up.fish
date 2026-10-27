#!/usr/bin/env fish

# Find the focused workspace index.
set ws (niri msg -j workspaces | jq -r '.[] | select(.is_focused) | .idx')

if test "$ws" != "1"
    niri msg action move-column-to-workspace-up
    exit 0
end

# On workspace 1: create a temporary named workspace
# at the top, then move the column into it.
set count (niri msg -j workspaces | jq 'length')

niri msg action set-workspace-name _tempws --workspace "$count"
niri msg action move-workspace-to-index 1 --reference _tempws
niri msg action move-column-to-workspace _tempws
niri msg action unset-workspace-name _tempws
