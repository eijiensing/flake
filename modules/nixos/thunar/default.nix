{pkgs, ...}: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      # Upstream thunar-archive-plugin only ships wrappers for Ark,
      # Engrampa and File Roller; this variant adds a dtrx backend (and
      # uses xarchiver for "Create Archive").
      thunar-archive-plugin-dtrx
    ];
  };

  # Thunar's thumbnail service. It pulls in ffmpegthumbnailer, poppler,
  # libopenraw, GStreamer and the image loaders (webp/heif/jxl/rsvg) so
  # images, videos and PDFs get real previews.
  services.tumbler.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    gvfs
    mtpfs
    libmtp
    ffmpegthumbnailer
  ];
}
