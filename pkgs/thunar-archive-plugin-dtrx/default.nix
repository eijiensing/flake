{pkgs}: let
  inherit (pkgs) lib;

  # Keep this in sync with TAP_MIME_TYPES in thunar-archive-plugin's
  # tap-provider.c. The plugin only offers "Extract Here"/"Extract To..."
  # for these types, and only if the selected handler has a matching
  # .tap wrapper in its libexec directory.
  archiveMimeTypes = [
    "application/x-7z-compressed"
    "application/x-7z-compressed-tar"
    "application/x-ar"
    "application/x-arj"
    "application/x-bzip"
    "application/x-bzip-compressed-tar"
    "application/x-bzip2"
    "application/x-bzip2-compressed-tar"
    "application/x-bzip3"
    "application/x-bzip3-compressed-tar"
    "application/x-cd-image"
    "application/x-compress"
    "application/x-compressed-tar"
    "application/x-deb"
    "application/x-gtar"
    "application/x-gzip"
    "application/x-jar"
    "application/x-java-archive"
    "application/x-lha"
    "application/x-lhz"
    "application/x-lrzip"
    "application/x-lrzip-compressed-tar"
    "application/x-lz4"
    "application/x-lz4-compressed-tar"
    "application/x-lzip"
    "application/x-lzip-compressed-tar"
    "application/x-lzma"
    "application/x-lzma-compressed-tar"
    "application/x-lzop"
    "application/x-rar"
    "application/x-rar-compressed"
    "application/vnd.rar"
    "application/vnd.comicbook-rar"
    "application/vnd.comicbook+zip"
    "application/x-cb7"
    "application/x-cbt"
    "application/x-rpm"
    "application/x-tar"
    "application/x-xz"
    "application/x-xz-compressed-tar"
    "application/x-zip"
    "application/x-zip-compressed"
    "application/x-zoo"
    "application/x-zstd-compressed-tar"
    "application/zip"
  ];

  runtimePath = lib.makeBinPath [
    pkgs.dtrx
    pkgs.xarchiver
    pkgs.zenity
    pkgs.file
    pkgs.unzip
    pkgs.unrar
    pkgs.p7zip
  ];

  # The plugin resolves its wrappers as
  #   $LIBEXECDIR/thunar-archive-plugin/<desktop-id>.tap
  # so the tap script below has the same basename as dtrx.desktop.
  dtrxTap = pkgs.writeText "dtrx.tap" "#!/bin/sh\nexec @out@/bin/dtrx-thunar \"$@\"\n";

  # A hidden desktop entry is still a valid MIME handler for GIO, which is
  # what thunar-archive-plugin uses to pick an archiver. NoDisplay keeps it
  # out of application menus. The Exec path must be absolute, otherwise
  # GIO refuses to load the entry when the binary is not in PATH yet.
  dtrxDesktop = pkgs.writeText "dtrx.desktop" (
    lib.concatStringsSep "\n" [
      "[Desktop Entry]"
      "Type=Application"
      "Version=1.0"
      "Name=Extract with dtrx"
      "GenericName=Archive Extractor"
      "Comment=Intelligently extract archives with dtrx"
      "Exec=@out@/bin/dtrx-thunar open %f"
      "Icon=package-x-generic"
      "Terminal=false"
      "NoDisplay=true"
      "Categories=Utility;Archiving;"
      "MimeType=${lib.concatStringsSep ";" archiveMimeTypes}"
      ""
    ]
  );
in
  pkgs.thunar-archive-plugin.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];

    # Upstream's archive-type table predates the modern RAR/comic-book MIME
    # types, so .rar files (application/vnd.rar) would not get an extraction
    # menu at all. Teach the plugin about them.
    postPatch =
      (old.postPatch or "")
      + ''
            substituteInPlace thunar-archive-plugin/tap-provider.c \
              --replace-fail '"application/x-rar",' '"application/x-rar",
        "application/vnd.rar",
        "application/vnd.comicbook-rar",
        "application/vnd.comicbook+zip",
        "application/x-cb7",
        "application/x-cbt",'
      '';

    postInstall =
      (old.postInstall or "")
      + ''
        install -Dm755 ${./dtrx-thunar.sh} $out/bin/dtrx-thunar
        substituteInPlace $out/bin/dtrx-thunar \
          --replace-fail '#!/usr/bin/env bash' '#!${pkgs.bash}/bin/bash'
        wrapProgram $out/bin/dtrx-thunar \
          --prefix PATH : ${runtimePath}

        install -Dm755 ${dtrxTap} $out/libexec/thunar-archive-plugin/dtrx.tap
        substituteInPlace $out/libexec/thunar-archive-plugin/dtrx.tap \
          --replace-fail '@out@' "$out"

        install -Dm644 ${dtrxDesktop} $out/share/applications/dtrx.desktop
        substituteInPlace $out/share/applications/dtrx.desktop \
          --replace-fail '@out@' "$out"
      '';
  })
