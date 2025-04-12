{ config, pkgs, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ (builtins.toString ./totoro.png) ];
      wallpaper = [
        ", ${builtins.toString ./totoro.png}"
      ];
    };
  };
}

