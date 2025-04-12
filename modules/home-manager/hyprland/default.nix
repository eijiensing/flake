 wayland.windowManager.hyprland = {
 	enable = true;
       plugins = [
       ];
       systemd.variables = [ "--all" ];
       settings = {
         input = {
           touchpad.natural_scroll = true;
         };
         "$mod" = "SUPER";
         "$terminal" = "alacritty";
         monitor = ", preferred, 0x0, 1";
         bind = [
           "$mod, Q, exec, $terminal"
           "$mod, C, killactive"
           "$mod, V, togglefloating"
           "$mod, F, exec, firefox"
           "$mod, M, exit"
           "$mod, H, movefocus, l"
           "$mod, J, movefocus, d"
           "$mod, K, movefocus, u"
           "$mod, L, movefocus, r"
         ] ++ (
       # workspaces
       # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
       builtins.concatLists (builtins.genList (i:
           let ws = i + 1;
           in [
             "$mod, code:1${toString i}, workspace, ${toString ws}"
             "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
           ]
         )
         9)
     );
		 };
 };
