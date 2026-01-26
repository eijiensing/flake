{ pkgs, ... }:
{
  home.packages = with pkgs; [
    grim
    slurp
		wf-recorder
  ];
}
