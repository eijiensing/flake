{ pkgs, ... }: {
    home.packages = with pkgs.unstable; [
        atlauncher
    ];

    xdg.desktopEntries = {
        atlauncher = {
            name = "AT Launcher";
            comment = "Minecraft mod manager";
            genericName = "atlauncher";
            exec = "atlauncher";
            terminal = false;
            categories = [];
            mimeType = [];
            icon = "atlauncher";
        };
    };
}
