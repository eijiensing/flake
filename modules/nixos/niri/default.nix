{
  pkgs,
  ...
}:
{
  programs.niri = {
    enable = true;
  };

  # Keep the portal setup that used to live in the Hyprland module.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.portal.OpenURI" = [ "gtk" ];
      };
    };
  };
}
