{ pkgs, ... }: {
  # For games and https://nix.dev/guides/faq#how-to-run-non-nix-executables
  
  environment.systemPackages = with pkgs; [
    nix-ld
  ];
  programs.nix-ld ={
    enable = true;
    libraries = with pkgs; [
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
      libxcb
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      mesa
      pango
      cairo
      systemd
      alsa-lib
      libgbm
      libGL
      libxcrypt
      udev
      libudev0-shim
      libva
      vulkan-loader
      libcap
    ];
  };
}
