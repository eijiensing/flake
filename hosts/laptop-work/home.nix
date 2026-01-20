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
		../../modules/home-manager/dotnet
		../../modules/home-manager/pgadmin
		../../modules/home-manager/postman
    ../../modules/home-manager/hurl
    ../../modules/home-manager/teams
    ../../modules/home-manager/vscode
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

  programs = {
    home-manager.enable = true;
    firefox.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
