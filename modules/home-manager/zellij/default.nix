{
  programs.zellij = {
    enable = true;
    settings = {
      pane.borderless=true;
      default_mode = "normal";
      pane_frames = false;
      theme = "gruvbox-dark";
      copy_on_select = false;
      show_release_notes = false;
      show_startup_tips = false;
      # default_layout = "compact";
    };
  };
}
