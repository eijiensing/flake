{ ... }: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        "browser.startup.page" = 1; # 1 = show homepage, 3 = restore session
        "browser.sessionstore.resume_from_crash" = false;
        "browser.sessionstore.max_resumed_crashes" = 0;
        "browser.sessionstore.enabled" = false;
      };
    };

  };
}
