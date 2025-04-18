{...}: {

 wayland.windowManager.hyprland = {
 	enable = true;
       plugins = [
       ];
       systemd.variables = [ "--all" ];
       settings = {
         exec-once = [
	   "systemctl --user start hyprpaper.service"
	 ];
       	 
         input = {
           touchpad.natural_scroll = true;
         };
	 gestures = {
          workspace_swipe = true;
          workspace_swipe_distance = 200;
          workspace_swipe_forever = true;
        };
	 decoration = {
        rounding = 0;
        active_opacity = 0.90;
        inactive_opacity = 0.90;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          brightness = 1;
          contrast = 1.4;
          ignore_opacity = true;
          noise = 0;
          new_optimizations = true;
          xray = true;
        };

        shadow = {
          enabled = true;

          ignore_window = true;
          offset = "0 2";
          range = 20;
          render_power = 3;
          color = "rgba(00000055)";
        };
      };

      
      animations = {
        enabled = true;

        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "fade_curve, 0, 0.55, 0.45, 1"
        ];

        animation = [
          # name, enable, speed, curve, style

          # Windows
          "windowsIn,   0, 4, easeOutCubic,  popin 20%" # window open
          "windowsOut,  0, 4, fluent_decel,  popin 80%" # window close.
          "windowsMove, 1, 2, fluent_decel, slide" # everything in between, moving, dragging, resizing.

          # Fade
          "fadeIn,      1, 3,   fade_curve" # fade in (open) -> layers and windows
          "fadeOut,     1, 3,   fade_curve" # fade out (close) -> layers and windows
          "fadeSwitch,  0, 1,   easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow,  1, 10,  easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim,     1, 4,   fluent_decel" # the easing of the dimming of inactive windows
          # "border,      1, 2.7, easeOutCirc"  # for animating the border's color switch speed
          # "borderangle, 1, 30,  fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
          "workspaces,  1, 4,   easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
        ];
      };
      general = {
        "$mod" = "SUPER";
        "$terminal" = "alacritty";
        layout = "dwindle";
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgb(98971A) rgb(CC241D) 45deg";
        "col.inactive_border" = "0x00000000";
        # border_part_of_window = false;
        no_border_on_floating = false;
      };

         monitor = ", preferred, 0x0, 1";
         bind = [
           "$mod, Q, exec, $terminal"
           "$mod, C, killactive"
           "$mod, V, togglefloating"
           "$mod, F, fullscreen"
           "$mod, B, exec, firefox"
           "$mod, M, exit"
           "$mod, H, movefocus, l"
           "$mod, J, movefocus, d"
           "$mod, K, movefocus, u"
           "$mod, L, movefocus, r"
	   ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
	   ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
	   ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
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
     bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
		 };
 };
 }
