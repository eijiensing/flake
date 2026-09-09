{ pkgs, ... }:
{
  home.packages = with pkgs; [
    grim
    slurp
    wf-recorder
    wl-clipboard # wl-copy/wl-paste for the Super+Shift+S region screenshot
  ];
}
