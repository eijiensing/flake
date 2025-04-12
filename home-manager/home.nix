# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/home-manager/neovim
    ../modules/home-manager/hyprpaper
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "eiji";
    homeDirectory = "/home/eiji";
  };


  programs = {
	  home-manager.enable = true;
	  firefox.enable = true;
	  alacritty.enable = true;
	  fish.enable = true;
	  git = {
	    enable = true;
	    userName = "eijiensing";
	    userEmail = "eijitron@gmail.com";
	  };
  };

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


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
