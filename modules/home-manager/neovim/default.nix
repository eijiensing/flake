{ pkgs, config, lib, inputs, ... }: let
  utils = inputs.nixCats.utils; in {
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    nixCats = {
      enable = true;
      # nixpkgs_version = pkgs.unstable;
      luaPath = "${./.}";

      packageNames = [ "nixCats" ];

      categoryDefinitions.replace = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
        lspsAndRuntimeDeps = {
          general = with pkgs.unstable; [
            universal-ctags
            ripgrep
            fd
          ];
          rust = with pkgs.unstable; [
            rust-analyzer
            rustc
            cargo
          ];
          neonixdev = {
            inherit (pkgs.unstable) nix-doc lua-language-server nixd;
          };
        };

        startupPlugins = {
          debug = with pkgs.unstable.vimPlugins; [
            nvim-nio
          ];
          general = with pkgs.unstable.vimPlugins; {
            always = [
              lze
              lzextras
              vim-repeat
              plenary-nvim
              nvim-notify
              gruvbox-material
              oil-nvim
              nvim-web-devicons
            ];
          };
        };

        optionalPlugins = {
          debug = with pkgs.unstable.vimPlugins; {
            default = [
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
            ];
          };
          lint = with pkgs.unstable.vimPlugins; [
            nvim-lint
          ];
          format = with pkgs.unstable.vimPlugins; [
            conform-nvim
          ];
          markdown = with pkgs.unstable.vimPlugins; [
            markdown-preview-nvim
          ];
          rust = with pkgs.unstable.vimPlugins; [
            rustaceanvim
          ];
          neonixdev = with pkgs.unstable.vimPlugins; [
            lazydev-nvim
          ];
          general = {
            blink = with pkgs.unstable.vimPlugins; [
              luasnip
              cmp-cmdline
              blink-cmp
              blink-compat
              colorful-menu-nvim
            ];
            treesitter = with pkgs.unstable.vimPlugins; [
              nvim-treesitter-textobjects
              nvim-treesitter.withAllGrammars
            ];
            telescope = with pkgs.unstable.vimPlugins; [
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              telescope-nvim
            ];
            always = with pkgs.unstable.vimPlugins; [
              nvim-lspconfig
              lualine-nvim
              gitsigns-nvim
              vim-sleuth
              vim-fugitive
              vim-rhubarb
              nvim-surround
            ];
            extra = with pkgs.unstable.vimPlugins; [
              fidget-nvim
              which-key-nvim
              comment-nvim
              undotree
              indent-blankline-nvim
              vim-startuptime
            ];
          };
        };

        python3.libraries = {
          test = (_:[]);
        };
        extraLuaPackages = {
          general = [ (_:[]) ];
        };

        extraCats = {
          test = [
            [ "test" "default" ]
          ];
          debug = [
            [ "debug" "default" ]
          ];
        };
      };



      packageDefinitions.replace = {
      nixCats = { pkgs, name, ... }@misc: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          aliases = [ "nvim" ];
          wrapRc = true;
          configDirName = "nixCats-nvim";
        neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        categories = {
          markdown = true;
          general = true;
          lint = true;
          format = true;
          neonixdev = true;
          lspDebugMode = true;
          colorscheme = "gruvbox-material";
        };
        extra = {
          nixdExtras = {
            nixpkgs = ''import ${pkgs.unstable.path} {}'';
          };
        };
      };
    };
  };
  };
}
