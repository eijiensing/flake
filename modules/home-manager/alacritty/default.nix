{ ... }:
{
  home.file.".local/share/shell/alacritty-themes".source = ./themes;
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "~/.local/share/shell/alacritty-theme.toml"
				"~/.config/alacritty/theme-trigger.toml"
      ];
      font.normal.family = "CaskaydiaMono Nerd Font Mono";
      font.normal.style = "regular";
      window.padding = {
        x = 16;
        y = 16;
      };
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
