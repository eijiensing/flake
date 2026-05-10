{
  pkgs,
  hostname,
  ...
}:
{
  home.packages = with pkgs; [
    brightnessctl
    wl-clipboard
    playerctl
    unstable.hyprshutdown
  ];

  home.file.".config/hypr".source = ./config;
  home.file.".config/hypr/host-config.lua".source =
    ../../../hosts/${hostname}/hyprland-host-config.lua;
}
