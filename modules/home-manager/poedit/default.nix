{ pkgs, ... }: {
	home.packages = with pkgs; [
		poedit
	];
}
