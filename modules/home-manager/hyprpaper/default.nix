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
        primary = "#5e534a";
        secondary = "#232522";
        background = "#0f1110";
        text = "#f9f8f6";
        alacritty = "alabaster_dark";
        neovim = "alabaster";
        dark = true;
      }
      {
        name = "A ridiculous smile";
        path = builtins.toString ./kleinsmile.webp;
        primary = "#b85348";
        secondary = "#806663";
        background = "#b3a5a2";
        text = "#302f34";
        alacritty = "seoul256-light";
        neovim = "seoul256-light";
        dark = false;
      }
    ];
  };
  services.hyprpaper = {
    enable = false;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      ipc = true;
      splash = false;
      preload = [
        (builtins.toString ./fy_bnb.webp)
        (builtins.toString ./fixedimmortaltravel.webp)
        (builtins.toString ./derrickdoors.webp)
        (builtins.toString ./kleinsmile.webp)
      ];
    };
  };
}
