{
  pkgs,
  hostname,
  lib,
  ...
}:
let
  hostConfig = ../../../hosts/${hostname}/niri-host-config.kdl;
in
{
  home.packages = [
    pkgs.xwayland-satellite # XWayland for X11-only apps (Steam, Discord, …)
    pkgs.gpui-shell # GPUI desktop shell (bar/island), spawned by niri at startup
  ];

	home.file.".config/niri/move-column-to-maybe-workspace-up.fish".source = ./move-column-to-maybe-workspace-up.fish;

  # niri reads a single KDL config file. The shared part lives in ./config.kdl;
  # the per-host part (outputs, etc.) is appended from
  # hosts/<hostname>/niri-host-config.kdl when that file exists.
  home.file.".config/niri/config.kdl".text =
    builtins.readFile ./config.kdl
    + lib.optionalString (builtins.pathExists hostConfig) ("\n" + builtins.readFile hostConfig);
}
