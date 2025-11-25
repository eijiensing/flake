{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.caskaydia-mono
			noto-fonts-cjk-sans
    ];
    fontconfig = {
      hinting.autohint = true;
    };
  };
}
