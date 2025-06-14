{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/nvidia
    ../../modules/nixos/wireguard
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

  networking.hostName = "desktop";

  programs = {
    fish.enable = true;
    command-not-found.enable = false;
  };

  users.users = {
    eiji = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "audio"];
    };
  };


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
