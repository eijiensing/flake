{ pkgs, ... }: {
    home.packages = with pkgs; [
    	discord
    ];
    xdg.desktopEntries = {
        discord = {
            name = "Discord";
            genericName = "Discord";
            exec = "discord";
            terminal = false;
            categories = [ "AudioVideo" "Network" "Chat"];
            mimeType = [];
            icon = "discord";
        };
    };
}
