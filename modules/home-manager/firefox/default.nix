{ config, ... }:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
    };
  };
}
