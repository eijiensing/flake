{
  home.file.".local/scripts/tmux-sessionizer.fish"  = {
    source = ./tmux-sessionizer.fish;
    executable = true;
  };
  programs.tmux = {
    enable = true;
  };
}
