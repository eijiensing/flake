{...}: {
  programs.fish = {
    enable = true;

    shellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings

      function fish_user_key_bindings
        bind -M insert \cy accept-autosuggestion
      end

      function fish_mode_prompt
        switch $fish_bind_mode
          case insert
            printf '\e[6 q'; # Beam (bar) cursor
            echo -n '[I] '
          case default
            printf '\e[2 q'; # Block cursor
            echo -n '[N] '
          case visual
            printf '\e[4 q'; # Underline cursor
            echo -n '[V] '
        end
      end
    '';
  };
}

