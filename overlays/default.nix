# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    atlauncher = prev.atlauncher.overrideAttrs (old: rec {
      version = "3.4.40.1";
      pname = "atlauncher";

      mitmCache = final.gradle.fetchDeps {
        inherit (final);

      pname = "atlauncher";
        data = ./deps.json;
      };

      gradleFlags = [
        "--exclude-task"
        "createExe"
        "-Dorg.gradle.java.home=${final.jdk17}"
      ];

      src = final.fetchFromGitHub {
        owner = "ATLauncher";
        repo = "ATLauncher";
        rev = "v${version}";
        hash = "sha256-oNWjYSz0lUuhcP/luSM/3u5+nB+g+0YLLyBanoMSmhQ="; # Replace with real hash
      };
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
