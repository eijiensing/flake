{
  pkgs,
  hostname,
  inputs,
  ...
}:
{
  home.packages = [
    pkgs.brightnessctl
    pkgs.wl-clipboard
    pkgs.playerctl
    pkgs.unstable.hyprshutdown
    inputs.hyprland-preview-share-picker.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file.".config/hypr" = {
    source = ./config;
    recursive = true;
  };
  home.file.".config/hypr/host-config.lua".source =
    ../../../hosts/${hostname}/hyprland-host-config.lua;
}
