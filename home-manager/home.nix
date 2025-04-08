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
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ../modules/home-manager/neovim
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
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


  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.alacritty.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish-greeting ""
    '';
  };

  wayland.windowManager.hyprland = {
  	enable = true;
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

  programs.git = {
    enable = true;
    userName = "eijiensing";
    userEmail = "eijitron@gmail.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
