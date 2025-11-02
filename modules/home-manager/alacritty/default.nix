{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      colors.primary.background = "#1D2021";
      font.normal.family = "CaskaydiaMono Nerd Font Mono";
      font.normal.style = "regular";
      window.padding = {
        x = 16;
        y = 16;
      };
    };
  };
  xdg.desktopEntries.alacritty = {
    name = "Alacritty";
    comment = "GPU-accelerated terminal emulator";
    exec = "alacritty %F";
    icon = "alacritty";
    type = "Application";
    categories = [ "System" "TerminalEmulator" "Utility" ];
    noDisplay = false;
  };
}

