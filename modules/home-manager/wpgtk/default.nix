{ ... }:
{
  home.packages = with pkgs; [ wpgtk ];
    home.file.".config/wpg/wpg.conf".text = ''
      [settings]
        set_wallpaper = false
        gtk = true
        active = 0
        light_theme = false
        editor = nvim
        execute_cmd = false
        command =
        backend = wal
        alpha = 100
        smart_sort = true
        auto_adjust = true
    '';
}
