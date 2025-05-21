{ config, pkgs, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ (builtins.toString ./fy_bnb.jpg) ];
      wallpaper = [
        ", ${builtins.toString ./fy_bnb.jpg}"
      ];
    };
  };
}

