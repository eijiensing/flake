{
  hostname,
  lib,
  ...
}:
let
  hostConfig = ../../../hosts/${hostname}/niri-host-config.kdl;
in
{
  # App launcher for the Super+R bind.
  programs.fuzzel.enable = true;

  # niri reads a single KDL config file. The shared part lives in ./config.kdl;
  # the per-host part (outputs, etc.) is appended from
  # hosts/<hostname>/niri-host-config.kdl when that file exists.
  home.file.".config/niri/config.kdl".text =
    builtins.readFile ./config.kdl
    + lib.optionalString (builtins.pathExists hostConfig) ("\n" + builtins.readFile hostConfig);
}
