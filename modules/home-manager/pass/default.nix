{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnupg
    pass
    pinentry-curses
  ];

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  services.pass-secret-service = {
    enable = true;
  };
}
