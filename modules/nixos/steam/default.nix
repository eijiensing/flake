{ ... }: {
    programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
    };
    programs.gamescope = {
        enable = true;
    };
    programs.gamemode.enable = true;
}
