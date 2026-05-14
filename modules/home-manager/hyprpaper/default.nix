{ inputs, pkgs, ... }:
{
  home.file.".local/share/themes.json".text = builtins.toJSON {
    wallpapers = [
      {
        name = "Footless bird";
        path = builtins.toString ./fy_bnb.jpg;
        primary = "#81A8DE";
        background = "#FCF6EA";
        secondary = "#978D74";
				text = "#000000";
      }
      {
        name = "Fixed Immortal Travel";
        path = builtins.toString ./fixedimmortaltravel.jpg;
        primary = "#876B22";
        secondary = "#4B3B2C";
        background = "#1D1916";
				text = "#876B22";
      }
    ];
  };
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      ipc = true;
      splash = false;
      preload = [
        (builtins.toString ./fy_bnb.jpg)
        (builtins.toString ./fixedimmortaltravel.jpg)
      ];
    };
  };
}
