{ pkgs, ...}: {
    home.packages = with pkgs; [
      protonup
    ];

    home.sessionVariables.STEAM_EXTRA_COMPAT_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
}
