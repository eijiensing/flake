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
    ../../modules/nixos/postgresql
    ../../modules/nixos/nix-ld
    ../../modules/nixos/appimage
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      rocmSupport = true;
      permittedInsecurePackages = [
        "python3.13-vllm-0.16.0"
      ];
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

  fileSystems."/drives/lexar" = {
    device = "/dev/disk/by-uuid/c279dda4-affc-4cc2-8fd4-776bb78de515";
    fsType = "ext4";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
