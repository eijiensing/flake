{ inputs, ... }: 
{
	imports = [ inputs.ags.homeManagerModules.default ];

	programs.ags = {
		enable = true;
	};
	
	home.file = {
		".config/ags/config.js".source = ./config/config.js;
	};
}
