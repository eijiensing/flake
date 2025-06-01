{ inputs, ... }: let
  utils = inputs.nixCats.utils; in {
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    nixCats = {
      enable = true;
      luaPath = "${./.}";

      packageNames = [ "nixCats" ];

      categoryDefinitions.replace = { pkgs, ... }@packageDef: {
        lspsAndRuntimeDeps = {
          general = with pkgs; [
            universal-ctags
            ripgrep
            fd
          ];
          neonixdev = {
            inherit (pkgs) nix-doc lua-language-server nixd;
          };
        };

        startupPlugins = {
          debug = with pkgs.vimPlugins; [
            nvim-nio
          ];
          general = with pkgs.vimPlugins; {
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
          debug = with pkgs.vimPlugins; {
            default = [
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
            ];
          };
          lint = with pkgs.vimPlugins; [
            nvim-lint
          ];
          format = with pkgs.vimPlugins; [
            conform-nvim
          ];
          markdown = with pkgs.vimPlugins; [
            markdown-preview-nvim
          ];
          rust = with pkgs.vimPlugins; [
            rustaceanvim
          ];
          neonixdev = with pkgs.vimPlugins; [
            lazydev-nvim
          ];
          general = {
            blink = with pkgs.vimPlugins; [
              luasnip
              cmp-cmdline
              blink-cmp
              blink-compat
              colorful-menu-nvim
            ];
            treesitter = with pkgs.vimPlugins; [
              nvim-treesitter-textobjects
              nvim-treesitter.withAllGrammars
            ];
            telescope = with pkgs.vimPlugins; [
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              telescope-nvim
            ];
            always = with pkgs.vimPlugins; [
              nvim-lspconfig
              lualine-nvim
              gitsigns-nvim
              vim-sleuth
              vim-fugitive
              vim-rhubarb
              nvim-surround
            ];
            extra = with pkgs.vimPlugins; [
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
      nixCats = { pkgs, ... }@misc: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          aliases = [ "nvim" ];
          wrapRc = true;
          configDirName = "nixCats-nvim";
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
          rust = true;
          colorscheme = "gruvbox-material";
        };
        extra = {
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
          };
        };
      };
    };
  };
  };
}
