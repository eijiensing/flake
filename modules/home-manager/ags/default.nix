{ inputs, pkgs, ... }: 
{
	imports = [ inputs.ags.homeManagerModules.default ];

	programs.ags = {
		enable = true;
		configDir = ./config;
		extraPackages = with pkgs; [
			inputs.ags.packages.${pkgs.system}.astal-hyprland
		];
	};
}
