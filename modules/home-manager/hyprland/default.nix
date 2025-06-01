{ pkgs, ...}: {
  home.packages = with pkgs; [
    brightnessctl
    wl-clipboard
  ];

  home.file.".local/bin/app-launcher-toggle.sh".source = ./app-launcher-toggle.sh;

  wayland.windowManager.hyprland = {
    xwayland.enable = true;
    enable = true;

    plugins = [
    ];

    systemd.variables = [ "--all" ];

    settings = {
      
      exec-once = [
        "systemctl --user start hyprpaper.service"
        "ags run ~/.config/ags/bar.ts"
      ];
       
      input = {
        touchpad.natural_scroll = true;
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_distance = 200;
        workspace_swipe_forever = true;
      };
      misc = {
        disable_hyprland_logo=true;
        disable_splash_rendering=true;
      };
      decoration = {
        rounding = 8;
        active_opacity = 0.95;
        inactive_opacity = 0.83;
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
          "windows,1,4,default,slide" # window open
          "border,1,5,default" # fade in (open) -> layers and windows
          "fade,1,5,default" # fade out (close) -> layers and windows
          "workspaces,1,3,default" # fade on changing activewindow and its opacity
        ];
      };

      general = {
        "$mod" = "SUPER";
        "$terminal" = "alacritty";
        "$file_browser" = "thunar";
        layout = "dwindle";
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgb(98971A) rgb(CC241D) 45deg";
        "col.inactive_border" = "0x00000000";
        # border_part_of_window = false;
        no_border_on_floating = false;
      };

      monitor = ["HDMI-A-1, preferred, 1920x0, 1" "DP-3,preferred, 0x0, 1"];
      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, G, exec, $file_browser"
        "$mod, C, killactive"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, B, exec, firefox"
        "$mod, M, exit"
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod, P, exec, hyprlock"
        "$mod, R, exec, ~/.local/bin/app-launcher-toggle.sh"
        "$mod SHIFT, P, movecurrentworkspacetomonitor, +1"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next "
        ", XF86AudioPrev, exec, playerctl previous"
      ] ++ (
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
