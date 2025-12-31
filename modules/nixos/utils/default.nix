{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.htop
    pkgs.nvtopPackages.amd
    pkgs.nvtopPackages.nvidia
  ];
  services.upower.enable = true;
  time.timeZone = "Europe/Amsterdam";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
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
