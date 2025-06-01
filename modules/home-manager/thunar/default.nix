{ pkgs, ... }: {
  home.packages = with pkgs; [
    #File browser + thumbnail service
    xfce.thunar xfce.tumbler
  ];

  xdg.mime.enable = false;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["Thunar.desktop"];
      "image/png" = ["imv.desktop"];
      "image/jpeg" = ["imv.desktop"];
    };
  };
}
