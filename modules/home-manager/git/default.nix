{ config, lib, pkgs, name, email, ... }:

{
  options = {
    gitName = lib.mkOption {
      type = lib.types.str;
      description = "Git user name";
    };
    gitEmail = lib.mkOption {
      type = lib.types.str;
      description = "Git user email";
    };
  };

  config = {
    programs.git = {
      enable = true;
      userName = name;
      userEmail = email;
    };

    home.packages = [ pkgs.gh ];
  };
}

