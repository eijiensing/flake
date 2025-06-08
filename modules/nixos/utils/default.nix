{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.unzip
  ];
  services.upower.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "Europe/Amsterdam";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
  };
}
