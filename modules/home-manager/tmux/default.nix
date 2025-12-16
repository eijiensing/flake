{
  programs.tmux = {
    enable = true;
		terminal = "tmux-256color";
    keyMode = "vi";
    escapeTime = 0;
		extraConfig = "set -ag terminal-overrides \",xterm-256color:RGB\"";
  };
}
