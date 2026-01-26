{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    hyprlandMonitor = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Hyprland monitor configuration";
    };

    hyprlandWorkspace = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Hyprland workspace configuration";
    };

    hyprlandDevice = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            name = lib.mkOption { type = lib.types.str; };
            output = lib.mkOption { type = lib.types.str; };
          };
        }
      );
      default = null;
      description = "Hyprland input device binding";
    };
  };

  config = {
    home.packages = with pkgs; [
      brightnessctl
      wl-clipboard
      playerctl
    ];

    home.file.".local/bin/center_all.fish".source = ./center_all.fish;

    wayland.windowManager.hyprland = {
      xwayland.enable = true;
      enable = true;

      systemd.variables = [ "--all" ];

      settings = {
        workspace = config.hyprlandWorkspace;
        monitor = config.hyprlandMonitor;
        device = lib.mkIf (config.hyprlandDevice != null) config.hyprlandDevice;

        exec-once = [
          "systemctl --user start hyprpaper.service"
          "quickshell"
          "hyprctl dispatch workspace 1"
        ];

        input = {
          touchpad.natural_scroll = true;
          kb_options = [ "caps:escape" ];
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
        decoration = {
          rounding = 16;

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
            "windows,1,4,default,slide"
            "border,1,5,default"
            "fade,1,5,default"
            "workspaces,1,3,default"
          ];
        };

        general = {
          "$mod" = "SUPER";
          "$terminal" = "alacritty";
          "$browser" = "firefox";
          "$file_browser" = "thunar";
          layout = "dwindle";
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = "rgb(81A8DE) rgb(8fb5eb) 45deg";
          "col.inactive_border" = "0x00000000";
          no_border_on_floating = false;
        };

        bind = [
          "$mod, Q, exec, $terminal"
          "$mod, G, exec, $file_browser"
          "$mod, C, killactive"
          "$mod, V, togglefloating"
          "$mod, F, fullscreen"
          "$mod, B, exec, $browser"
          "$mod, M, exit"
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"
          "$mod, R, exec, rofi -show drun"
          "$mod, E, global, quickshell:sidebarToggle"
          "$mod, P, movecurrentworkspacetomonitor, +1"
          "SUPER_SHIFT, C, exec, ~/.local/bin/center_all.fish"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next "
          ", XF86AudioPrev, exec, playerctl previous"
          ", Print, exec, grim -g \"$(slurp)\" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        ));
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
