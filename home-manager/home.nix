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
    ../modules/home-manager/hyprland
    ../modules/home-manager/fish
    ../modules/home-manager/alacritty
    ../modules/home-manager/nix-index
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
    packages = with pkgs; [
  	wl-clipboard
    ];

  };


  programs = {
	  home-manager.enable = true;
	  firefox.enable = true;
	  git = {
	    enable = true;
	    userName = "eijiensing";
	    userEmail = "eijitron@gmail.com";
	  };
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
