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

  boot.kernelModules = [ "nvidia" ];
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.loader.grub.extraConfig = ''
    set os-prober=true
  '';

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false; # set to true if you want to try the open-source driver
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
boot.kernelParams = [ "nvidia-drm.modeset=1" ];

 environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GL_VRR_ALLOWED = "1";
    WLR_DRM_NO_MODIFIERS = "1";
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "Europe/Amsterdam";
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  security.pam.services.hyprlock = {};

fonts = {
    packages = with pkgs; [
          nerd-fonts.caskaydia-mono
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
  system.stateVersion = "25.05";
}
