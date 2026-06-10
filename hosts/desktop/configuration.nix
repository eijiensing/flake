{
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/nixos/amd
    ../../modules/nixos/docker
    ../../modules/nixos/flatpak
    ../../modules/nixos/java
    ../../modules/nixos/steam
    ../../modules/nixos/ratbag
    ../../modules/nixos/postgresql
    ../../modules/nixos/nix-ld
    ../../modules/nixos/ollama
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
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "docker"
        "input"
      ];
    };
  };

  fileSystems."/drives/hdd" = {
    device = "/dev/disk/by-uuid/1fc9b3cd-81cd-4136-a378-ab3e39a1328b";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
