{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    extraPackages = [
      pkgs.hidapi # this was fixed in steam, by the time you eiji are reading this, its prob fixed
    ];
    gamescopeSession.enable = true;
  };
  programs.gamescope = {
    enable = true;
  };
  programs.gamemode.enable = true;
	hardware.steam-hardware.enable = true;
}
