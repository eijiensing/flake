{ pkgs, ... }: {
	programs.thunar = {
		enable = true;
		plugins = with pkgs.xfce; [ thunar-volman ];
	};
  services.gvfs.enable = true;
	services.udisks2.enable = true;
	environment.systemPackages = with pkgs; [
		gvfs
		mtpfs
		libmtp
	];
}
