{ pkgs, ... }: {
		# this is a torrent client
    home.packages = with pkgs; [
        transmission_4
    ];
}
