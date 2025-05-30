{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    # package = pkgs.unstable.alacritty;
    settings = {
    font.normal.family = "CaskaydiaMono Nerd Font Mono";
    font.normal.style = "regular";
      window.padding = {
        x = 16;
        y = 16;
      };
    };
  };
}

