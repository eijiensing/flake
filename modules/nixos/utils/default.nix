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
  # systemd-resolved resolves .local over mDNS, but unlike services.avahi it
  # does not open the mDNS port itself; without this the firewall drops the
  # inbound responses and lookups time out.
  networking.firewall.allowedUDPPorts = [ 5353 ];
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
