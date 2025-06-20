{ pkgs, ... }: {
    home.packages = with pkgs; [
        clapper
    ];
}
