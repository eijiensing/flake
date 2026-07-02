{ pkgs, ... }: {
  home.packages = with pkgs; [
		deepfilternet
    easyeffects
  ];

  services.easyeffects = {
      enable = true;
  };
}
