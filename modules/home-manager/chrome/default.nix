{ pkgs, ... }: {
	home.packages = with pkgs; [
		ungoogled-chrome
	];
}
