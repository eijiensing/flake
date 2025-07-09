{...}: {
programs.fish = {
  enable = true;

  shellInit = ''
    # 0. Use vi‑style keys
    set -g fish_key_bindings fish_vi_key_bindings

    # 1. Define *all* custom bindings here
    function fish_user_key_bindings
        # Keep the ↵ autosuggestion accept in insert mode
        bind -M insert \cy accept-autosuggestion
        bind -M insert  \cf 'tmux-sessionizer.fish'
        bind -M default \cf 'tmux-sessionizer.fish'
    end

    # 2. Misc prompt & helpers (unchanged)
    function fish_greeting
      echo Good afternoon, Mr. Fool~\n
    end

    function fish_prompt
      set -g __fish_git_prompt_showdirtystate 1
      printf '%s%s%s ' (prompt_pwd) (set_color normal) (fish_git_prompt)
    end

    function fish_mode_prompt
      switch $fish_bind_mode
        case default
          set_color --bold red
        case insert replace_one
          set_color --bold green
        case visual
          set_color --bold brmagenta
        case '*'
          set_color --bold red
      end
      printf '%s ' $USER
      set_color normal
    end

    function develop --wraps='nix develop'
      env ANY_NIX_SHELL_PKGS=(basename (pwd))"#"(git describe --tags --dirty) (type -P nix) develop --command fish
    end

    # 3. Ensure the script directory is on PATH
    fish_add_path -g $HOME/.local/scripts
  '';
};
}

