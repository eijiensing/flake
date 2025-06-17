{...}: {
  programs.fish = {
    enable = true;

    shellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings

      function fish_user_key_bindings
        bind -M insert \cy accept-autosuggestion
      end

      function fish_greeting
        echo Good afternoon, Mr. Fool~\n 
      end
      function fish_prompt -d "Write out the prompt"
          set -g __fish_git_prompt_showdirtystate 1
          printf '%s%s%s ' (prompt_pwd) (set_color normal) (fish_git_prompt)
      end

      function fish_mode_prompt
        switch $fish_bind_mode
          case default
            set_color --bold red
            printf '%s ' $USER
          case insert
            set_color --bold green
            printf '%s ' $USER
          case replace_one
            set_color --bold green
            printf '%s ' $USER
          case visual
            set_color --bold brmagenta
            printf '%s ' $USER
          case '*'
            set_color --bold red
            printf '%s ' $USER
        end
        set_color normal
      end

      function develop --wraps='nix develop'
        env ANY_NIX_SHELL_PKGS=(basename (pwd))"#"(git describe --tags --dirty) (type -P nix) develop --command fish
      end
      '';
  };
}

