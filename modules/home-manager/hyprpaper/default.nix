{ config, pkgs, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      preload = [
        (builtins.toString ./fy_bnb.jpg)
        (builtins.toString ./fixedimmortaltravel.jpg)
      ];
      wallpaper = [
        ", ${builtins.toString ./fy_bnb.jpg}"
      ];
    };
  };
}
