{ inputs, pkgs, ... }: 
{
	imports = [ inputs.ags.homeManagerModules.default ];

	programs.ags = {
		enable = true;
		configDir = ./config;
		extraPackages = with pkgs; [
			inputs.ags.packages.${system}.hyprland
			inputs.ags.packages.${system}.mpris
			inputs.ags.packages.${system}.battery
			inputs.ags.packages.${system}.wireplumber
			inputs.ags.packages.${system}.tray
			inputs.ags.packages.${system}.network
			adwaita-icon-theme
		];
	};
}
