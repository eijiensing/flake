{ inputs, pkgs, config, ... }: 
{
	imports = [ inputs.ags.homeManagerModules.default ];
    
  home.file.".config/ags".source =
  config.lib.file.mkOutOfStoreSymlink ./config;

  programs.ags = {
    enable = true;
    configDir = null;#./config;
    extraPackages = with pkgs; [
      inputs.ags.packages.${system}.apps
      inputs.ags.packages.${system}.hyprland
      inputs.ags.packages.${system}.mpris
      inputs.ags.packages.${system}.battery
      inputs.ags.packages.${system}.wireplumber
      inputs.ags.packages.${system}.tray
      inputs.ags.packages.${system}.network
      inputs.ags.packages.${system}.notifd
      adwaita-icon-theme
    ];
  };
}
