{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      colors.primary.background = "#1d2021";
      font.normal.family = "CaskaydiaMono Nerd Font Mono";
      font.normal.style = "regular";
      window.padding = {
        x = 16;
        y = 16;
      };
    };
  };
}

