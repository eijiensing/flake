#!/usr/bin/env fish

set ws (hyprctl activeworkspace -j | jq -r .id)

for addr in (hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ws) | .address")
    hyprctl dispatch focuswindow 0x$addr
    hyprctl dispatch centerwindow
end
