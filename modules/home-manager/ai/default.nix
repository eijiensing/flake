{ pkgs, ... }: {
  home.packages = with pkgs; [
    unstable.deepseek-harness
  ];
}
