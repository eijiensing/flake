{ inputs, pkgs, ... }: {
  home.file.".config/nvim/init.lua".source = ./nvim/init.lua;
	home.packages = [
		pkgs.nixd
		pkgs.lua-language-server
	];
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
