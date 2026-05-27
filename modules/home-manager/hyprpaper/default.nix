{ inputs, pkgs, ... }:
{
  home.file.".local/share/shell/themes.json".text = builtins.toJSON {
    wallpapers = [
      {
        name = "Footless bird";
        path = builtins.toString ./fy_bnb.webp;
        primary = "#81A8DE";
        background = "#FCF6EA";
        secondary = "#978D74";
        text = "#000000";
        alacritty = "dawnfox";
        neovim = "dawnfox";
        dark = false;
      }
      {
        name = "Fixed Immortal Travel";
        path = builtins.toString ./fixedimmortaltravel.webp;
        primary = "#876B22";
        secondary = "#4B3B2C";
        background = "#1D1916";
        text = "#876B22";
        alacritty = "kanagawa-dragon";
        neovim = "kanagawa-dragon";
        dark = true;
      }
      {
        name = "Light was the meaning to everything";
        path = builtins.toString ./derrickdoors.webp;
        primary = "#f8f2e7";
        secondary = "#faf6f5";
        background = "#0f1110";
        text = "#f8f2e7";
        alacritty = "kanagawa-dragon";
        neovim = "kanagawa-dragon";
        dark = true;
      }
      {
        name = "A ridiculous smile";
        path = builtins.toString ./kleinsmile.webp;
        primary = "#7e6b65";
        secondary = "#7e6b65";
        background = "#a2958e";
        text = "#302f34";
        alacritty = "kanagawa-dragon";
        neovim = "kanagawa-dragon";
        dark = true;
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
