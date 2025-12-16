{ inputs, pkgs, ... }: {
  # home.file.".config/quickshell".source = ./config;
	qt = {
		enable = true;
		platformTheme.name = "org.kde.desktop";
	};
  home.packages = [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
		pkgs.unstable.kdePackages.kdialog
		pkgs.unstable.kdePackages.kirigami
		pkgs.unstable.kdePackages.kirigami-addons
		pkgs.unstable.kdePackages.qt5compat
		pkgs.unstable.kdePackages.qtbase
		pkgs.unstable.kdePackages.qtdeclarative
		pkgs.unstable.kdePackages.qtdeclarative
		pkgs.unstable.kdePackages.qtimageformats
		pkgs.unstable.kdePackages.qtmultimedia
		pkgs.unstable.kdePackages.qtpositioning
		pkgs.unstable.kdePackages.qtquicktimeline
		pkgs.unstable.kdePackages.qtsensors
		pkgs.unstable.kdePackages.qtsvg
		pkgs.unstable.kdePackages.qttools
		pkgs.unstable.kdePackages.qttranslations
		pkgs.unstable.kdePackages.qtvirtualkeyboard
		pkgs.unstable.kdePackages.qtwayland
		pkgs.unstable.kdePackages.syntax-highlighting
  ];
}
