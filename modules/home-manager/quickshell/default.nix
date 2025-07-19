{ inputs, ... }: {
  # home.file.".config/quickshell".source = ./config;
  home.packages = [
    inputs.quickshell.packages."x86_64-linux".default
  ];
}
