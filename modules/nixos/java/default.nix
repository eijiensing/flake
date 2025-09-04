{ pkgs, ... }: {
    programs.java.enable = true;
    programs.java.package = pkgs.jdk;
		environment.systemPackages = with pkgs; [
			jdk8
		];
}
