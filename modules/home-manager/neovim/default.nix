{ unstablePkgs, config, lib, inputs, ... }: let
  utils = inputs.nixCats.utils; in {
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    # this value, nixCats is the defaultPackageName you pass to mkNixosModules
    # it will be the namespace for your options.
    nixCats = {
      enable = true;
      # nixpkgs_version = unstablePkgs;
      luaPath = "${./.}";

      packageNames = [ "nixCats" ];

      categoryDefinitions.replace = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
        # to define and use a new category, simply add a new list to a set here, 
        # and later, you will include categoryname = true; in the set you
        # provide when you build the package using this builder function.
        # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

        # lspsAndRuntimeDeps:
        # this section is for dependencies that should be available
        # at RUN TIME for plugins. Will be available to PATH within neovim terminal
        # this includes LSPs
        lspsAndRuntimeDeps = {
          # some categories of stuff.
          general = with pkgs; [
            universal-ctags
            ripgrep
            fd
          ];
          # these names are arbitrary.
          lint = with pkgs; [
          ];
          # but you can choose which ones you want
          # per nvim package you export
          debug = with pkgs; {
            go = [ delve ];
          };
          go = with pkgs; [
            gopls
            gotools
            go-tools
            gccgo
          ];
          # and easily check if they are included in lua
          format = with pkgs; [
          ];
          neonixdev = {
            # also you can do this.
            inherit (pkgs) nix-doc lua-language-server nixd;
            # and each will be its own sub category
          };
        };

        # This is for plugins that will load at startup without using packadd:
        startupPlugins = {
          debug = with pkgs.vimPlugins; [
            nvim-nio
          ];
          general = with unstablePkgs.vimPlugins; {
            # you can make subcategories!!!
            # (always isnt a special name, just the one I chose for this subcategory)
            always = [
              lze
              lzextras
              vim-repeat
              plenary-nvim
              nvim-notify
            ];
            extra = [
              oil-nvim
              nvim-web-devicons
            ];
          };
          # You can retreive information from the
          # packageDefinitions of the package this was packaged with.
          # :help nixCats.flake.outputs.categoryDefinitions.scheme
          themer = with pkgs.vimPlugins;
            (builtins.getAttr (categories.colorscheme or "gruvbox-material") {
                # Theme switcher without creating a new category
                "gruvbox-material" = gruvbox-material;
                "onedark" = onedark-nvim;
                "catppuccin" = catppuccin-nvim;
                "catppuccin-mocha" = catppuccin-nvim;
                "tokyonight" = tokyonight-nvim;
                "tokyonight-day" = tokyonight-nvim;
              }
            );
            # This is obviously a fairly basic usecase for this, but still nice.
        };

        # not loaded automatically at startup.
        # use with packadd and an autocommand in config to achieve lazy loading
        # or a tool for organizing this like lze or lz.n!
        # to get the name packadd expects, use the
        # `:NixCats pawsible` command to see them all
        optionalPlugins = {
          debug = with pkgs.vimPlugins; {
            # it is possible to add default values.
            # there is nothing special about the word "default"
            # but we have turned this subcategory into a default value
            # via the extraCats section at the bottom of categoryDefinitions.
            default = [
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
            ];
            go = [ nvim-dap-go ];
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
          neonixdev = with pkgs.vimPlugins; [
            lazydev-nvim
          ];
          general = {
            blink = with unstablePkgs.vimPlugins; [
              luasnip
              cmp-cmdline
              blink-cmp
              blink-compat
              colorful-menu-nvim
            ];
            treesitter = with pkgs.vimPlugins; [
              nvim-treesitter-textobjects
              nvim-treesitter.withAllGrammars
              # This is for if you only want some of the grammars
              # (nvim-treesitter.withPlugins (
              #   plugins: with plugins; [
              #     nix
              #     lua
              #   ]
              # ))
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
              # lualine-lsp-progress
              which-key-nvim
              comment-nvim
              undotree
              indent-blankline-nvim
              vim-startuptime
              # If it was included in your flake inputs as plugins-hlargs,
              # this would be how to add that plugin in your config.
              # pkgs.neovimPlugins.hlargs
            ];
          };
        };

        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = with pkgs; [ # <- this would be included if any of the subcategories of general are
            # libgit2
          ];
        };

        # environmentVariables:
        # this section is for environmentVariables that should be available
        # at RUN TIME for plugins. Will be available to path within neovim terminal
        environmentVariables = {
          test = {
            default = {
              CATTESTVARDEFAULT = "It worked!";
            };
            subtest1 = {
              CATTESTVAR = "It worked!";
            };
            subtest2 = {
              CATTESTVAR3 = "It didn't work!";
            };
          };
        };

        # If you know what these are, you can provide custom ones by category here.
        # If you dont, check this link out:
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
        extraWrapperArgs = {
          test = [
            '' --set CATTESTVAR2 "It worked again!"''
          ];
        };

        # lists of the functions you would have passed to
        # python.withPackages or lua.withPackages
        # do not forget to set `hosts.python3.enable` in package settings

        # get the path to this python environment
        # in your lua config via
        # vim.g.python3_host_prog
        # or run from nvim terminal via :!<packagename>-python3
        python3.libraries = {
          test = (_:[]);
        };
        # populates $LUA_PATH and $LUA_CPATH
        extraLuaPackages = {
          general = [ (_:[]) ];
        };

        # see :help nixCats.flake.outputs.categoryDefinitions.default_values
        # this will enable test.default and debug.default
        # if any subcategory of test or debug is enabled
        # WARNING: use of categories argument in this set will cause infinite recursion
        # The categories argument of this function is the FINAL value.
        # You may use it in any of the other sets.
        extraCats = {
          test = [
            [ "test" "default" ]
          ];
          debug = [
            [ "debug" "default" ]
          ];
          go = [
            [ "debug" "go" ] # yes it has to be a list of lists
          ];
        };
      };



      packageDefinitions.replace = {
      # the name here is the name of the package
      # and also the default command name for it.
      nixCats = { pkgs, name, ... }@misc: {
        # these also recieve our pkgs variable
        # see :help nixCats.flake.outputs.packageDefinitions
        settings = {
          suffix-path = true;
          suffix-LD = true;
          # The name of the package, and the default launch name,
          # and the name of the .desktop file, is `nixCats`,
          # or, whatever you named the package definition in the packageDefinitions set.
          # WARNING: MAKE SURE THESE DONT CONFLICT WITH OTHER INSTALLED PACKAGES ON YOUR PATH
          # That would result in a failed build, as nixos and home manager modules validate for collisions on your path
          aliases = [ "nvim" "vimcat" ];

          # explained below in the `regularCats` package's definition
          # OR see :help nixCats.flake.outputs.settings for all of the settings available
          wrapRc = true;
          configDirName = "nixCats-nvim";
        neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        # enable the categories you want from categoryDefinitions
        categories = {
          markdown = true;
          general = true;
          lint = true;
          format = true;
          neonixdev = true;
          test = {
            subtest1 = true;
          };

          # enabling this category will enable the go category,
          # and ALSO debug.go and debug.default due to our extraCats in categoryDefinitions.
          # go = true; # <- disabled but you could enable it with override or module on install

          # this does not have an associated category of plugins, 
          # but lua can still check for it
          lspDebugMode = false;
          # you could also pass something else:
          # see :help nixCats
          themer = true;
          colorscheme = "gruvbox-material";
        };
        extra = {
          # to keep the categories table from being filled with non category things that you want to pass
          # there is also an extra table you can use to pass extra stuff.
          # but you can pass all the same stuff in any of these sets and access it in lua
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
            # or inherit nixpkgs;
          };
        };
      };
      regularCats = { pkgs, ... }@misc: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          # IMPURE PACKAGE: normal config reload
          # include same categories as main config,
          # will load from vim.fn.stdpath('config')
          wrapRc = false;
          # or tell it some other place to load
          # unwrappedCfgPath = "/some/path/to/your/config";

          # configDirName: will now look for nixCats-nvim within .config and .local and others
          # this can be changed so that you can choose which ones share data folders for auths
          # :h $NVIM_APPNAME
          configDirName = "nixCats-nvim";

          aliases = [ "testCat" ];

          # If you wanted nightly, uncomment this, and the flake input.
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          # Probably add the cache stuff they recommend too.
        };
        categories = {
          markdown = true;
          general = true;
          neonixdev = true;
          lint = true;
          format = true;
          test = true;
          # go = true; # <- disabled but you could enable it with override or module on install
          lspDebugMode = false;
          themer = true;
          colorscheme = "gruvbox-material";
        };
        extra = {
          # nixCats.extra("path.to.val") will perform vim.tbl_get(nixCats.extra, "path" "to" "val")
          # this is different from the main nixCats("path.to.cat") in that
          # the main nixCats("path.to.cat") will report true if `path.to = true`
          # even though path.to.cat would be an indexing error in that case.
          # this is to mimic the concept of "subcategories" but may get in the way of just fetching values.
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
            # or inherit nixpkgs;
          };
          # yes even tortured inputs work.
          theBestCat = "says meow!!";
          theWorstCat = {
            thing'1 = [ "MEOW" '']]' ]=][=[HISSS]]"[['' ];
            thing2 = [
              {
                thing3 = [ "give" "treat" ];
              }
              "I LOVE KEYBOARDS"
              (utils.n2l.types.inline-safe.mk ''[[I am a]] .. [[ lua ]] .. type("value")'')
            ];
            thing4 = "couch is for scratching";
          };
        };
      };
    };



    };

  };
}
