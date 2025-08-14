{ inputs, pkgs, ... }: {
  home.file.".config/nvim/init.lua".source = ./lua/init.lua;
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };
}
