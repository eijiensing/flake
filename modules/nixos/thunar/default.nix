{ pkgs, ... }: {
  # environment.systemPackages = with pkgs; [
  #   gvfs
  #   jmtpfs
  # libmtp
  #   simple-mtpfs
  #   android-udev-rules
  # ];
	programs.thunar = {
		enable = true;
		plugins = with pkgs.xfce; [ thunar-volman ];
	};
  services.gvfs.enable = true;
  # services.udisks2.enable = true;
}
