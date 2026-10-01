{ pkgs, inputs }:
{
  # My GPUI desktop shell. The derivation lives (inline) in the gpui-shell
  # flake; we just re-export its package output here so it is available as
  # `pkgs.gpui-shell`.
  gpui-shell = inputs.gpui-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
}
