{ config, inputs, pkgs, ... }:
let
  ytFirefox = inputs.yt-firefox.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  programs.firefox = {
    enable = true;
    # The extension is built from source and is not signed by AMO. Release
    # Firefox ignores xpinstall.signatures.required, so use Developer Edition
    # where signing is not required.
    package = pkgs.firefox-devedition;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      id = 0;
      # Developer Edition treats a profile without this exact name as a first
      # run and tries to rewrite profiles.ini, which is a read-only symlink to
      # the Nix store in Home Manager. The path stays "default".
      name = "dev-edition-default";
      isDefault = true;
    };

    policies = {
      ExtensionSettings = {
        "yt-mp3@eijiens.ing" = {
          installation_mode = "force_installed";
          install_url = "file://${ytFirefox}/yt-firefox.xpi";
        };
      };

      # Required for the unsigned, locally built XPI. Locked so it cannot
      # be toggled off. This is only effective in ESR/Developer Edition.
      Preferences."xpinstall.signatures.required" = {
        Value = false;
        Status = "locked";
      };
    };
  };
}
