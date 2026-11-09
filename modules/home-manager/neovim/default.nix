{ inputs, pkgs, ... }:
{
  home.packages = [
    pkgs.nixd
    pkgs.nixfmt
    pkgs.lua-language-server
    pkgs.ripgrep
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    withPython3 = false;
    withRuby = false;
    initLua = builtins.readFile ./nvim/init.lua;
  };
}
