{ pkgs, ... }: {
  # For games and https://nix.dev/guides/faq#how-to-run-non-nix-executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    icu77
    glibc
    glib
    zlib
    nss
    nspr
    dbus
    at-spi2-atk
    cups
    expat
    libxkbcommon
    at-spi2-core
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    mesa
    pango
    cairo
    systemd
    alsa-lib
    libgbm
  ];
}
