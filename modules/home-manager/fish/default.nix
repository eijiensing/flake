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

				# Nix shell indicator
				if set -q IN_NIX_SHELL
						set nix_indicator " (nix)"
				else
						set nix_indicator ""
				end

				printf '%s%s%s%s ' (prompt_pwd) $nix_indicator (set_color normal) (fish_git_prompt)
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

    function dev --wraps='nix develop'
				nix develop --command fish
    end

		function hm --wraps=home-manager --description "home-manager switch --flake . (shortcut)"
				home-manager switch --flake . $argv
		end

		function nr --wraps=nixos-rebuild --description "nixos-rebuild switch --flake . (shortcut)"
				if test (id -u) -ne 0
						sudo nixos-rebuild switch --flake . $argv
				else
						nixos-rebuild switch --flake . $argv
				end
		end

    # 3. Ensure the script directory is on PATH
    fish_add_path -g $HOME/.local/scripts
  '';
};
}

