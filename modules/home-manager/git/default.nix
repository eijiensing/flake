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
			settings = {
				user.email = config.gitEmail;
				user.name = config.gitName;
			};
		};
		programs.gh = {
			enable = true;
		};
	};
}
