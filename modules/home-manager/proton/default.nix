{ pkgs, ...}: {
    home.packages = with pkgs; [
      protonup-ng
    ];

    home.sessionVariables.STEAM_EXTRA_COMPAT_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
}
