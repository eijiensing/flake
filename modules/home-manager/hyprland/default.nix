{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    brightnessctl
    wl-clipboard
    playerctl
    unstable.hyprshutdown
  ];

  home.file.".config/hypr/host-config.lua".source =
    ../../../hosts/${config.networking.hostName}/hyprland-host-config.lua;
}
