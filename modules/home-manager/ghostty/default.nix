{ ... }:
{
  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    systemd.enable = true;
    enableFishIntegration = true;
    settings = {
      font-family = "CaskaydiaMono Nerd Font Mono";
      font-size = 11;
      window-padding-x = 16;
      window-padding-y = 16;
			quit-after-last-window-closed = true;
			quit-after-last-window-closed-delay = "5m";
      config-file = "/home/eiji/.config/ghostty/theme.ghostty";
    };
  };
}
