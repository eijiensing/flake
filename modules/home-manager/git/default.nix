{ config, lib, ... }: {
	options = {
		gitName = lib.mkOption {
			type = lib.types.str;
			description = "Git user name";
		};
		gitEmail = lib.mkOption {
			type = lib.types.str;
			description = "Git user email";
		};
	};

	config = {
		programs.git = {
			enable = true;
			userName = config.gitName;
			userEmail = config.gitEmail;
		};
		programs.gh = {
			enable = true;
		};
	};
}
