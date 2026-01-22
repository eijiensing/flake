{ inputs, pkgs, ... }: {
  home.file.".config/quickshell".source = ./config;
	qt = {
		enable = true;
	};
  home.packages = [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
	];
}
