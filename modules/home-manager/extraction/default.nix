{ pkgs, ... }: {
  home.packages = with pkgs; [
    unzip
    unrar
    p7zip
		dtrx # Do The Right eXtraction
  ];
}
