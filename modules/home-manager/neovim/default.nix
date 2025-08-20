{ inputs, pkgs, ... }: {
  home.file.".config/nvim/init.lua".source = ./nvim/init.lua;
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };
}
