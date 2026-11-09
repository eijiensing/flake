{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.file
    pkgs.btop
    pkgs.nvtopPackages.amd
    pkgs.nvtopPackages.nvidia
  ];
  services.upower.enable = true;
  time.timeZone = "Europe/Amsterdam";
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.networkmanager = {
    enable = true;
    settings = {
      connection."connection.mdns" = 2;
    };
  };
  services.resolved = {
    enable = true;
    settings.Resolve.MulticastDNS = "true";
  };
  services.pipewire = {
    enable = true;
    audio.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  programs.dconf.enable = true;
}
