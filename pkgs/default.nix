{
  pkgs,
  inputs,
}: {
  # My GPUI desktop shell. The derivation lives (inline) in the gpui-shell
  # flake; we just re-export its package output here so it is available as
  # `pkgs.gpui-shell`.
  gpui-shell = inputs.gpui-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # thunar-archive-plugin with a dtrx backend and an xarchiver-backed
  # "Create Archive" action.
  thunar-archive-plugin-dtrx = import ./thunar-archive-plugin-dtrx {inherit pkgs;};
}
