{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.caskaydia-mono
    ];
    fontconfig = {
      hinting.autohint = true;
    };
  };
}
