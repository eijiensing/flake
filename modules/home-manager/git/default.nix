{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    gitName = mkOption {
      type = types.str;
      description = "Git user name";
    };
    gitEmail = mkOption {
      type = types.str;
      description = "Git user email";
    };
  };

 config = {
  programs.git = {
  enable = true;
    userName = config.gitName;
    userEmail = config.gitEmail;
  };
  programs.gh = {
    enable = true;
  };
  };
  
}
