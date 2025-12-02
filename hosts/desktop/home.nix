{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager
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

	hyprlandDevice = {
		name = "ugtablet-deco-01-stylus";
		output = "DP-3";
	};
	hyprlandWorkspace = ["1,monitor:DP-3" "2,monitor:HDMI-A-1"];
	hyprlandMonitor = ["DP-3, highrr, 0x0, 1" "HDMI-A-1, highrr, 1920x0, 1"];


  programs = {
    home-manager.enable = true;
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
