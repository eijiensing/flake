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
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/terminal" = "ghostty.desktop";
  };
  home.sessionVariables = {
    TERMINAL = "ghostty";
  };
  # For thunar
  home.file.".config/xfce4/helpers.rc".text = ''
    TerminalEmulator=ghostty
  '';
}
