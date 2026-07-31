{ inputs, pkgs, ... }:
# let
#   metaball-blobs = inputs.metaball-blobs.packages.${pkgs.stdenv.hostPlatform.system}.metaball-blobs;
# in
{
  qt = {
    enable = true;
  };
  home.packages = [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    # metaball-blobs
    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qt5compat
  ];
  # home.sessionVariables = {
  #   QML_IMPORT_PATH = "${metaball-blobs}/lib/qt6/qml";
  # };
}
