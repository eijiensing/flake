{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
		../../modules/home-manager
    ../../modules/home-manager/discord
    ../../modules/home-manager/neovim
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };
  home = {
    username = "eiji";
    homeDirectory = "/home/eiji";
  };

  gitName = "eijiensing";
  gitEmail = "eijitron@gmail.com";

	hyprlandMonitor = [
		"eDP-1, preferred, 0x0, 1"
	];

  programs = {
    home-manager.enable = true;
    firefox.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
