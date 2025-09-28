#!/usr/bin/env fish

set ws (hyprctl activeworkspace -j | jq -r .id)
for addr in (hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ws) | .address")
    hyprctl dispatch centerwindow address:$addr
end
