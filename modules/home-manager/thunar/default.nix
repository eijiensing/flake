{...}: {
  # Thunar stores its preferences in the `thunar` xfconf channel. Setting
  # the thumbnail mode explicitly makes sure thumbnails are on (including
  # on non-local mounts); the actual generation is done by tumbler, which
  # is enabled in modules/nixos/thunar.
  xfconf.settings.thunar = {
    "misc-thumbnail-mode" = "THUNAR_THUMBNAIL_MODE_ALWAYS";
  };
}
