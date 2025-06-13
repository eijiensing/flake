{ ... }: {
    programs.steam = {
        enable = true;
        gamescopeSession = true;
    };
    programs.gamescope = {
        enable = true;
    };
    programs.gamemode.enable = true;
}
