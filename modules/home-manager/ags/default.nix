{ inputs, ... }: 
{
	imports = [ inputs.ags.homeManagerModules.default ];

	programs.ags = {
		enable = true;
	};
	
	home.file = {
		".config/ags/app.js".source = ./config/app.js;
	};
}
