{ ... }:
{
  home.file.".config/alacritty/theme-trigger.toml".text = "";
  home.file.".local/state/alacritty/enfocado_light.toml".source = ./enfocado_light.toml;

  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "~/.local/state/alacritty/enfocado_light.toml"
        "~/.config/alacritty/theme-trigger.toml"
      ];
      font.normal.family = "CaskaydiaMono Nerd Font Mono";
      font.normal.style = "regular";
      window.padding = {
        x = 16;
        y = 16;
      };
      terminal.osc52 = "CopyPaste";
    };
  };
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/terminal" = "alacritty.desktop";
  };
  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
  # For thunar
  home.file.".config/xfce4/helpers.rc".text = ''
    TerminalEmulator=alacritty
  '';
}
