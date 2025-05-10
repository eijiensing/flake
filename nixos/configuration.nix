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

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "Europe/Amsterdam";
  networking.hostName = "laptop";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

fonts = {
    packages = with pkgs; [
          nerdfonts
        ];
    fontconfig = {
      hinting.autohint = true;
    };
  };

  services.displayManager.ly ={
    enable = true;
  };
  
  services.pipewire = {
	enable = true;
	audio.enable = true;
  };

  programs = {
	  hyprland = {
	    enable = true;
	    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
	  };
	  fish.enable = true;
	  command-not-found.enable = false;
  };
  


  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    eiji = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "audio"];
    };
  };

  services.upower.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
